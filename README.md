# Legion Pro 7i 16IRX8H Arch Linux Installation
<!--toc:start-->
- [Legion Pro 7i 16IRX8H Arch Linux Installation](#legion-pro-7i-16irx8h-arch-linux-installation)
  - [Prerequisites](#prerequisites)
    - [Getting an installation medium](#getting-an-installation-medium)
      - [Getting the ISO](#getting-the-iso)
      - [Preparing an installation medium](#preparing-an-installation-medium)
  - [Working with the live environment](#working-with-the-live-environment)
    - [Boot up the live environment](#boot-up-the-live-environment)
    - [Get connected to the internet](#get-connected-to-the-internet)
    - [Running the archinstall script](#running-the-archinstall-script)
  - [Post-install configuration](#post-install-configuration)
    - [Connect to the internet](#connect-to-the-internet)
    - [Clone this repository to get the helper script](#clone-this-repository-to-get-the-helper-script)
    - [Installing yay and get the essentials](#installing-yay-and-get-the-essentials)
    - [Install packages and config files](#install-packages-and-config-files)
    - [Post install configuration](#post-install-configuration-1)
    - [Configure Limine bootloader](#configure-limine-bootloader)
    - [Rebuild initramfs](#rebuild-initramfs)
    - [Begin hyprland](#begin-hyprland)
    - [Configure git information](#configure-git-information)
    - [Setup nvim](#setup-nvim)
    - [Setup theme](#setup-theme)
  - [That's it, we're done](#thats-it-were-done)
<!--toc:end-->

## Prerequisites

$\text{\color{cyan} [IMPORTANT] \color{yellow} You need to have internet and a
USB drive!}$

### Getting an installation medium

You will need an existing OS for this, so don't wipe your drive yet.

#### Getting the ISO

Visit [Arch download page](https://archlinux.org/download/) and download the ISO.

To verify the download is good, we can use the `sha256` hash.

On Windows, open Powershell to the directory containing the ISO and run:

```powershell
Get-FileHash .\arch-linux-<version>-x86_64.iso -Algorithm SHA256
```

On Linux, open the terminal to the directory containing the ISO and run:

```bash
sha256sum ./arch-linux-<version>-x86_64.iso
```

The number printed out should match the website's `SHA256` number.

#### Preparing an installation medium

I recommend using [Ventoy](https://www.ventoy.net/en/index.html) for ease of booting
ISO files. Follow [instructions from their website](https://www.ventoy.net/en/doc_start.html)
and put the downloaded ISO to the correct partition on the USB drive.

## Working with the live environment

### Boot up the live environment

Make sure to plug the USB drive in the laptop. Restart the laptop and press F12
repeatedly. This should bring up the boot menu. Select the USB drive from the list.

The Ventoy menu should appear, choose the downloaded ISO from the list.

Now the ISO will run and a list will appear, choose `Arch Linux install medium`
and press Enter to enter the installation environment.

### Get connected to the internet

First things first, let's get connected to the internet.

If you're using Ethernet, you're fine. If it is not connected, try unplugging the
Ethernet cable and plug it back in.

If you're using wifi, connect to the internet with `iwctl`:

```bash
iwctl
```

Now, inside iwctl:

```bash
adapter list
```

If the adapter `Powered` property is off, we have to turn it on.

For my machine, the adapter name is `phy0`. So I have to run:

```bash
adapter phy0 set-property Powered on
```

After that, run:

```bash
station list
```

You will see a station, mine is called `wlan0`, you can scan for networks using:

```bash
station wlan0 scan
```

Get the networks:

```bash
station wlan0 get-networks
```

Connect to the network:

```bash
station wlan0 connect <network_name>
```

### Running the archinstall script

Update the archinstall script first.

```bash
pacman -Sy
pacman -S archinstall
```

And run it:

```bash
archinstall
```

Go through with the `archinstall` script. My choices:

- Setup the mirrorlist
- Best-effort default partition layout with btrfs, luks with snapper, use the
standard subvolumes
- Swap on zram with zstd
- Limine bootloader
- Profile: Minimal
- Kernel: linux
- For applications, enable Bluetooth, pipewire, print service, and firewalld,
and all fonts
- For network, use network manager with iwd backend

Then just install. After installation, just reboot to the newly installed OS

## Post-install configuration

Log in with user account from tty.

### Connect to the internet

First things first, let's get connected to the internet.

If you're using Ethernet, you're fine. If it is not connected, try unplugging the
Ethernet cable and plug it back in.

If you're using wifi, connect to the internet with `nmcli` or `nmtui`, just do:

```bash
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect <WIFI_NAME>
```

### Clone this repository to get the helper script

```bash
sudo pacman -S git
git clone https://github.com/tuasananh/dotfiles --depth=1
cd dotfiles
```

### Installing yay and get the essentials

In the `dotfiles` repository folder:

```bash
./pkgman yay
```

After this `yay` is installed.

### Install packages and config files

In the `dotfiles` repository folder, inspect the `included_packages` file and
remove those that you don't need:

```bash
./pkgman install
```

After that, to apply user and system configurations:

```bash
./pkgman apply
```

> [!NOTE]
> `pkgman apply` will:
> 1. Use GNU Stow to symlink home directory configs (`nvim`, `hypr`, `kitty`, etc.) to `~`.
> 2. Use `syssync` (our custom system sync tool) to safely copy and track system-wide configurations (`/etc` and `/boot`) with correct permissions and root ownership.
> 3. Install the `syssync` background systemd service to sync any edits you make under `system/` instantly.

### Managing System Configurations (`syssync`)

For configurations in `/etc` and `/boot`, we use a custom-built Python utility called `syssync` instead of standard GNU Stow to avoid permission/readability issues for restricted system daemons (like `udev`, `systemd-resolved`, PAM, etc.).

You can run `syssync` manually to manage system files:

* **Show current status** (compares source files with live system files):
  ```bash
  ./syssync status
  ```
* **View colorized line-by-line diffs**:
  ```bash
  ./syssync diff
  ```
* **Pull active system-side changes back into your dotfiles**:
  ```bash
  ./syssync pull
  ```
* **Manually push your dotfiles to the system** (requires sudo):
  ```bash
  sudo ./syssync push
  ```
* **Manually install the real-time background syncing daemon** (requires sudo):
  ```bash
  sudo ./syssync install-service
  ```

### Package Tracking & Conflict Resolution (`pkgman`)

To maintain consistency between your dotfiles repository package lists and your actual system packages, you can use these `pkgman` developer workflow commands:

* **Show package discrepancies**:
  ```bash
  ./pkgman diff
  ```
* **Launch the Interactive Conflict Resolver TUI**:
  Runs a terminal-based interactive TUI prompting you for every discrepancy (untracked live packages or missing tracked packages) and allows you to add/ignore/install/remove them instantly:
  ```bash
  ./pkgman fix
  # OR
  ./pkgman diff --fix
  ```
* **Save package tracking list** (based on explicitly installed packages, excluding ignored packages):
  ```bash
  ./pkgman save
  ```

### Post install configuration

Run this:

```bash
./pkgman setup
```

### Configure Limine bootloader

Run:

```bash
./pkgman limine
```

### Rebuild initramfs

```bash
sudo mkinitcpio -P
```

$\text{\color{cyan} [IMPORTANT] \color{yellow} Reboot your computer!}$

### Begin hyprland

After the reboot, login normally and use `uwsm start hyprland.desktop` to start
hyprland, use `WIN + T` to open up the terminal.

Press `WIN + B` and open up Brave and navigate to `https://github.com/tuasananh/dotfiles`,
or [this link](https://github.com/tuasananh/dotfiles) for easier copy and paste.

### Configure git information

Configure git user.name and user.email:

```bash
git config --global user.name <name>
git config --global user.email <email>
```

Authenticate via Github:

```bash
gh auth login
```

### Setup nvim

After that, run `nvim` and wait for its installation.

### Setup theme

Run:

```bash
nwg-look
```

Choose Noto Fonts and the first catppuccin theme, prefer dark.

## That's it, we're done
