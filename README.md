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
    - [Installing some dev dependencies](#installing-some-dev-dependencies)
    - [Begin hyprland](#begin-hyprland)
    - [Setupnvim](#setupnvim)
    - [Change DNS resolver](#change-dns-resolver)
    - [Fix audio issues](#fix-audio-issues)
    - [Authentication agent](#authentication-agent)
    - [Docker](#docker)
    - [Installing AUR deps](#installing-aur-deps)
<!--toc:end-->

Boot up the live ISO and then connect to WiFi using `iwctl`, then use
`archinstall` to begin installation

For some systems, WiFi can be configured when opening `archinstall`, but not for
my laptop. So you have to manually connect to WiFi with `iwctl`.

Use `help` inside `iwctl` to see what to do.

## archinstall

Go through with the `archinstall` script. My choices:

- Best-effort default partition layout with ext4
- Swap on zram with zstd
- systemd-boot with UKI enabled
- Profile: Minimal
- Kernel: linux-lts
- For applications, enable Bluetooth, pipewire, print service, tuned, and firewalld,
and all fonts
- For network, use network manager with iwd backend
- For additional packages, choose:
  - 7zip
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
  - hyprland
  - hyprpicker
  - hyprpolkitagent
  - hyprshot
  - i2c-tools
  - imagemagick
  - intel-media-driver
  - jdk21-openjdk
  - jq
  - kitty
  - lazygit
  - less
  - linux-lts-headers
  - luarocks
  - mako
  - man-db
  - man-pages
  - mermaid-cli
  - neovim
  - nvidia-open-dkms
  - nvm
  - nwg-look
  - progress
  - ripgrep
  - rofi
  - rofi-calc
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

### Installing some dev dependencies

Install `nodejs` with `pnpm`:

```bash
nvm install stable
npm install -g corepack
corepack enable pnpm
pnpm -v
```

After this, reboot your computer.

### Begin hyprland

Use `uwsm start hyprland.desktop` to start hyprland, use `WIN + T` to
open up the terminal. And a browser for ease of copy and paste.

### Setupnvim

After that, run `nvim` and wait for its installation.

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

# Enforce DNS-over-TLS (Strict mode)
DNSOverTLS=yes

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

Open `nwg-look` and choose the first theme.
