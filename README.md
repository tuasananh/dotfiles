# Begin installation

<!--toc:start-->
- [Begin installation](#begin-installation)
  - [archinstall](#archinstall)
  - [Post-install configuration](#post-install-configuration)
    - [Setup mirrorlist](#setup-mirrorlist)
    - [Configure git information](#configure-git-information)
    - [Connect to the internet](#connect-to-the-internet)
    - [Stow config files](#stow-config-files)
    - [Enable waybar](#enable-waybar)
    - [Begin hyprland](#begin-hyprland)
    - [Installing some dev dependencies](#installing-some-dev-dependencies)
    - [Setup nvim](#setup-nvim)
    - [Installing AUR deps](#installing-aur-deps)
    - [Configure limine bootloader](#configure-limine-bootloader)
    - [Change DNS resolver](#change-dns-resolver)
    - [Fix audio issues](#fix-audio-issues)
    - [Authentication agent](#authentication-agent)
    - [Docker](#docker)
    - [Unblock bluetooth](#unblock-bluetooth)
    - [Use aria2c instead of curl for makepkg (optional)](#use-aria2c-instead-of-curl-for-makepkg-optional)
<!--toc:end-->

Boot up the live ISO and then connect to WiFi using `iwctl`, then use
`archinstall` to begin installation

For some systems, WiFi can be configured when opening `archinstall`, but not for
my laptop. So you have to manually connect to WiFi with `iwctl`.

Use `help` inside `iwctl` to see what to do.

## archinstall

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
- For additional packages, choose:
  - 7zip
  - act
  - audacity
  - base-devel
  - brightnessctl
  - btop
  - chromium
  - clang
  - cliphist
  - cmake
  - dbeaver
  - docker
  - docker-compose
  - fcitx5
  - fcitx5-bamboo
  - fcitx5-configtool
  - fd
  - firefox
  - fzf
  - ghostscript
  - git
  - git-filter-repo
  - git-lfs
  - github-cli
  - gptfdisk
  - hyprland
  - hyprpicker
  - hyprpolkitagent
  - hyprshot
  - i2c-tools
  - imagemagick
  - intel-media-driver
  - intellij-idea-community-edition
  - jdk21-openjdk
  - jq
  - kitty
  - lazygit
  - less
  - linux-headers
  - luarocks
  - mako
  - man-db
  - man-pages
  - mermaid-cli
  - neovim
  - networkmanager-dmenu
  - nvidia-open-dkms
  - nvidia-prime
  - nvm
  - nwg-look
  - progress
  - ripgrep
  - rofi
  - rofi-calc
  - rofi-emoji
  - rustup
  - starship
  - stow
  - swaybg
  - tealdeer
  - tectonic
  - tree-sitter-cli
  - unzip
  - uv
  - uwsm
  - vim
  - vpl-gpu-rt
  - vulkan-intel
  - waybar
  - wl-clipboard
  - xdg-desktop-portal-gtk
  - xdg-desktop-portal-hyprland
  - yazi
  - zoxide

Then just install. After installation, just reboot to the newly installed OS

## Post-install configuration

Log in with user account from tty.

### Setup mirrorlist

If you haven't select mirrors, you can edit `/etc/pacman.d/mirrorlist`, should
uncomment your country and Worldwide only.

### Configure git information

Configure git user.name and user.email:

```bash
git config --global user.name <name>
git config --global user.email <email>
```

### Connect to the internet

Connect to the internet with `nmcli` or `nmtui`, just do:

```bash
nmcli device wifi rescan
nmcli device wifi list
nmcli device wifi connect <WIFI_NAME>
```

### Stow config files

Run:

```bash
git clone https://github.com/tuasananh/dotfiles
```

Remove `~/.bashrc` and `~/.config/hypr`. After that go to the cloned directory
and run:

```bash
git lfs install 
git lfs pull
stow */
```

### Enable waybar

Since waybar is not currently configured, we just configure it:

```bash
systemctl enable --user waybar
```

After this, reboot your computer.

### Begin hyprland

Use `uwsm start hyprland.desktop` to start hyprland, use `WIN + T` to
open up the terminal. And a browser for ease of copy and paste.

### Installing some dev dependencies

Install `nodejs` with `pnpm`:

```bash
nvm install stable
npm install -g corepack
corepack enable pnpm
pnpm -v
```

### Setup nvim

After that, run `nvim` and wait for its installation.

### Installing AUR deps

Install `yay` for `ble.sh` (bash on crack):

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si
```

Install `ble.sh`:

```bash
yay -S blesh-git
```

Now install brave:

```bash
yay -S brave-bin
```

Now install the Catppuccin Mocha theme:

```bash
yay -S catppuccin-gtk-theme-mocha
```

Open `nwg-look` and choose the first theme. After that change the fonts to Noto
Sans Regular and make Color theme prefer dark.

### Configure limine bootloader

Paste this for Catppuccin Mocha theme on top of the `/boot/limine/limine.conf` file:

```conf
term_palette: 1e1e2e;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
term_palette_bright: 585b70;f38ba8;a6e3a1;f9e2af;89b4fa;f5c2e7;94e2d5;cdd6f4
term_background: 1e1e2e
term_foreground: cdd6f4
term_background_bright: 585b70
term_foreground_bright: cdd6f4
```

If dual booting, add Windows inside as well, it is something like:

```conf
/Windows 11:
    protocol: efi 
    path: guid(<guid>):/EFI/Microsoft/Boot/bootmgfw.efi
```

The UUID can be found by using:

```bash
lsblk -dno PARTUUID /dev/nvmeXXXX
```

where /dev/nvmeXXXX

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

On my machine (Legion Pro 7i 16IRX8H), there is an issue with sound driver which
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

Reboot your computer.

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
