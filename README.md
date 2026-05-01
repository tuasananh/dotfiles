# Begin installation

<!--toc:start-->
- [Begin installation](#begin-installation)
  - [archinstall](#archinstall)
  - [Reboot and get into the newly added OS](#reboot-and-get-into-the-newly-added-os)
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
  - git
  - git-filter-repo
  - git-lfs
  - github-cli
  - hyprland
  - hyprpolkitagent
  - i2c-tools
  - intel-media-driver
  - jdk21-openjdk
  - jq
  - kitty
  - lazygit
  - less
  - linux-lts-headers
  - mako
  - man-db
  - man-pages
  - neovim
  - nvidia-open-dkms
  - nvm
  - progress
  - ripgrep
  - rofi
  - rofi-calc
  - rustup
  - starship
  - stow
  - swaybg
  - tealdeer
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

Then just install.

## Reboot and get into the newly added OS

If you haven't select mirrors, you can edit `/etc/pacman.d/mirrorlist`, should
uncomment your country and Worldwide only.

Configure git user.name and user.email:

```bash
git config --global user.name <name>
git config --global user.email <email>
```

Connect to internet with `nmcli` or `nmtui` and clone this repository:

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

Install `nodejs`:

```bash
nvm install stable
npm install -g corepack
corepack enable pnpm
pnpm -v
```

After we're done, enable `waybar` with:

```bash
systemctl enable --now --user waybar
```

Reboot and use `uwsm start hyprland.desktop` to start hyprland, use `WIN + T` to
open up the terminal.

After that, run `nvim` and wait for its installation.

I recommend changing the DNS resolver (to access more websites):

```bash
sudo nvim /etc/systemd/resolved.conf
```

Change `DNS` to `1.1.1.1 1.0.0.1` and uncomment the fallback:
<!-- markdownlint-disable MD013 -->
```conf
[Resolve]
DNS=1.1.1.1 1.0.0.1
FallbackDNS=9.9.9.9#dns.quad9.net 2620:fe::9#dns.quad9.net 1.1.1.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 8.8.8.8#dns.google 2001:4860:4860::8888#dns.google
```
<!-- markdownlint-enable MD013 -->

After this, run:

```bash
systemctl enable --now systemd-resolved
```

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

Next, enable the authentication agent:

```bash
systemctl enable --user hyprpolkitagent
```

Enable docker:

```bash
systemctl enable --now docker
sudo groupadd docker
sudo usermod -aG docker $(whoami)
```

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
