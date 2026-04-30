# Begin installation

Boot up the live ISO and then connect to WiFi using `iwctl`, then use `archinstall` to begin installation

For some systems, WiFi can be configured when opening `archinstall`, but not for my laptop. So you have to manually connect to WiFi with `iwctl`.

Use `help` inside `iwctl` to see what to do.

## archinstall

Go through with the `archinstall` script. My choices:

- Best-effort default partition layout with ext4
- Swap on zram with zstd
- systemd-boot with UKI enabled
- Profile: Minimal
- For applications, enable Bluetooth, tuned, and firewalld, and all fonts
- For network, use network manager with iwd backend
- For additional packages, choose `7zip base-devel brightnessctl btop chromium clang cliphist fcitx5 fcitx5-bamboo fcitx5-configtool fd firefox fzf git git-filter-repo git-lfs github-cli hyprland kitty lazygit less mako man-db man-pages neovim nvm progress rofi rofi-calc rustup starship stow swaybg tealdeer unzip uwsm vim waybar wl-clipboard zoxide`

Then just install.

