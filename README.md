# Legion Pro 7i 16IRX8H Arch Linux Installation

## Prerequisites

$\text{\color{cyan} [IMPORTANT] \color{yellow} You need to have internet an a
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
- For applications, enable Bluetooth, pipewire, print service, tuned, and firewalld,
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

### Installing yay and get the essentials

Install `yay`:

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

Go to the dotfiles directory and run:

```bash
yay -S $(cat included_packages)
```

### Stow config files

Run the following to stow the config files:

```bash
git clone https://github.com/tuasananh/dotfiles
cd dotfiles
git lfs install 
git lfs pull
rm ~/.bashrc
stow */
```

### Enable waybar

Since waybar is not currently enabled, we just enable it:

```bash
systemctl enable --user waybar
```

$\text{\color{cyan} [IMPORTANT] \color{yellow} Reboot your computer!}$

### Begin hyprland

After the reboot, login normally and use `uwsm start hyprland.desktop` to start hyprland, use `WIN + T` to
open up the terminal.

Press `WIN + B` and open up Brave and navigate to `https://github.com/tuasananh/dotfiles`,
or [this link](https://github.com/tuasananh/dotfiles) for easier copy and paste.

### Installing some dev dependencies

Install `nodejs` with `pnpm`:

```bash
nvm install stable
npm install -g corepack
corepack enable pnpm
pnpm -v
```

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

### Configure Limine bootloader

Paste this for Catppuccin Mocha theme on top of the `/boot/limine/limine.conf` file:

```conf
term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
term_background: 1e1e2e
term_foreground: cdd6f4
term_background_bright: 585b70
term_foreground_bright: cdd6f4

interface_branding:
```

If dual booting, add Windows inside as well, it is something like:

```conf
/Windows 11
    protocol: efi 
    path: guid(<guid>):/EFI/Microsoft/Boot/bootmgfw.efi
```

The UUID can be found by using:

```bash
lsblk -dno PARTUUID /dev/nvmeXXXX
```

where /dev/nvmeXXXX is the partition in which Windows `bootmgfw.efi` file resides.

You can list partitions with:

```bash
lsblk
```

### Change DNS resolver

I recommend changing the DNS resolver (to access more websites):

```bash
sudo mkdir -p /etc/systemd/resolved.conf.d
sudo nvim /etc/systemd/resolved.conf.d/dns_servers.conf
```

Paste the following into the file:
<!-- markdownlint-disable MD013 -->
```conf
[Resolve]
# Primary DNS (Cloudflare) - Strict DoT with SNI validation
DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com

# Fallback DNS (Quad9 and Google) - Strict DoT with SNI validation
FallbackDNS=9.9.9.9#dns.quad9.net 2620:fe::9#dns.quad9.net 8.8.8.8#dns.google 2001:4860:4860::8888#dns.google

# Route all DNS traffic through these servers
Domains=~.

# We're going with opportunistic here instead of yes because captive portal will break
DNSOverTLS=opportunistic

# Allow DNSSEC downgrade if routing issues occur (optional but recommended)
DNSSEC=allow-downgrade
```
<!-- markdownlint-enable MD013 -->

Now, configure network manager:

```bash
sudo nvim /etc/NetworkManager/conf.d/dns.conf
```

Paste this:

```conf
[main]
dns=systemd-resolved
```

After this, symlink resolv.conf

```bash
sudo rm /etc/resolv.conf
sudo ln -rsf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

Now, restart the service:

```bash
sudo systemctl enable --now systemd-resolved.service
sudo systemctl restart NetworkManager.service
```

### Fix audio issues

On my machine (Legion Pro 7i 16IRX8H), there is an issue with sound driver whichg
causes the speaker to die after about 30 seconds of inactivity.

To fix this issue, we will do:

Credit to [this repo](https://github.com/DanielWeiner/tas2781-fix-16IRX8H)
<!-- markdownlint-disable MD013 -->
```bash
curl -s https://raw.githubusercontent.com/DanielWeiner/tas2781-fix-16IRX8H/refs/heads/main/install.sh | bash -s --
```
<!-- markdownlint-enable MD013 -->
This will disable the power saving feature which turn the speaker off for some
reason and fail to turn it back on

### Authentication agent

Next, enable the authentication agent:

```bash
systemctl enable --user hyprpolkitagent
```

### Docker

Enable docker:

```bash
systemctl enable --now docker
sudo groupadd docker
sudo usermod -aG docker $(whoami)
```

Reboot your computer for the changes to take effect.

### Unblock bluetooth

By default, bluetooth may be blocked, run:

```bash
rfkill unblock bluetooth
```

to unblock it.

### Use aria2c instead of curl for makepkg (optional)

```bash
sudo pacman -S aria2
```

```bash
sudo nvim /etc/makepkg.conf 
```

For `DLAGENTS`, use `aria2c`:
<!-- markdownlint-disable MD013 -->
```conf
DLAGENTS=('file::/usr/bin/curl -qgC - -o %o %u'
          'ftp::/usr/bin/curl -qgfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u'
          'http::/usr/bin/aria2c -s 16 -x 16 -k 1M --stream-piece-selector=random --min-split-size=1M %u -o %o'
          'https::/usr/bin/aria2c -s 16 -x 16 -k 1M --stream-piece-selector=random --min-split-size=1M %u -o %o'
          'rsync::/usr/bin/rsync --no-motd -z %u %o'
          'scp::/usr/bin/scp -C %u %o')
```
<!-- markdownlint-enable MD013 -->
