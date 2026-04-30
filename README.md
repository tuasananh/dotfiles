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
- For applications, enable Bluetooth, tuned, and firewalld, and all fonts
- For network, use network manager with iwd backend
- For additional packages, choose `7zip base-devel brightnessctl btop
chromium clang cliphist fcitx5 fcitx5-bamboo fcitx5-configtool fd firefox fzf
git git-filter-repo git-lfs github-cli hyprland kitty lazygit less mako man-db
man-pages neovim nvm progress rofi rofi-calc rustup starship stow swaybg tealdeer
unzip uwsm vim waybar wl-clipboard zoxide yazi`

Then just install.

## Reboot and get into the newly added OS

If you haven't select mirrors, you can edit `/etc/pacman.d/mirrorlist`, should
uncomment your country and Worldwide only.

After logging into the user account, use:

```bash
uwsm start select
```

and then select Hyprland to start.

Open kitty terminal with WIN + Q.

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

After that, run `nvim` and wait for its installation.

After we're done, enable `waybar` with:

```bash
systemctl enable --now --user waybar
```

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

We don't have audio yet, so install `pipewire`:

```bash
sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber
sudo pacman -S sof-firmware 
```

The package `jack2` may be in conflict, just remove it.

Enable the services:

```bash
systemctl enable --user --now pipewire
systemctl enable --user --now pipewire-pulse
systemctl enable --user --now wireplumber
```

On my machine (Legion Pro 7i 16IRX8H), there is an issue with sound driver which
causes the speaker to die after about 30 seconds of inactivity.

To fix this issue, we will do:

```bash
echo "options snd_hda_intel power_save=0 power_save_controller=N" | sudo tee /etc/modprobe.d/50-audio-powersave.conf
```

This will disable the power saving feature which turn the speaker off for some
reason and fail to turn it back on

Next, install an authentication agent:

```bash
sudo pacman -S hyprpolkitagent
systemctl enable --user hyprpolkitagent
```

Install the desktop portal:

```bash
sudo pacman -S xdg-desktop-portal-hyprland
```

Intel graphics:

```bash
sudo pacman -S mesa vulkan-intel
```

For hardware acceleration, VAAPI:

```bash
sudo pacman -S intel-media-driver
```

and VPL:

```bash
sudo pacman -S libvpl vpl-gpu-rt
```

NVIDIA graphics card:

```bash

```
