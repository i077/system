{ ... }:

{
  imports = [
    ./backup.nix
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./nixpkgs.nix
    ./power.nix
    ./printing.nix
    ./private.nix
    ./services.nix
    ./theming.nix
    ./users.nix
    ./xserver.nix
    ./yubikey.nix

    ./apps/alacritty.nix
    ./apps/defaults.nix
    ./apps/everdo.nix
    ./apps/firefox.nix
    ./apps/keybase.nix
    ./apps/neovim
    ./apps/password-store.nix
    ./apps/ptpython.nix
    ./apps/tmux.nix
    ./apps/zathura.nix

    ./env/autorandr.nix
    ./env/broot.nix
    ./env/direnv.nix
    ./env/dunst.nix
    ./env/fish.nix
    ./env/fzf.nix
    ./env/git.nix
    ./env/gpg-agent.nix
    ./env/home.nix
    ./env/i3.nix
    ./env/onedrive.nix
    ./env/packages.nix
    ./env/picom.nix
    ./env/polybar.nix
    ./env/rclone.nix
    ./env/redshift.nix
    ./env/rofi.nix
    ./env/wallpaper.nix
  ];
}
