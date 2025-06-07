#!/bin/bash

# Update system and install packages
echo "Installing required packages..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
  breeze-gtk python-pywal zsh eza gparted hypridle hyprland hyprlock kitty nwg-look \
  qt6ct rofi-wayland starship thunar viu \
  xdg-desktop-portal-hyprland wl-clipboard brightnessctl swww

yay -S --needed --noconfirm \
  bibata-cursor-theme ags-hyprpanel-git hyprshot waypaper wlogout

# Install fonts
echo "Installing fonts..."
sudo pacman -S --needed --noconfirm \
  ttf-jetbrains-mono ttf-font-awesome ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd inter-font ttf-fira-code

yay -S --needed --noconfirm otf-apple-fonts

# Create symbolic links for configuration directories and files
echo "Creating symbolic links..."
ln -s ~/.config/dotfiles/kitty ~/.config/kitty
ln -s ~/.config/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -s ~/.config/dotfiles/waypaper ~/.config/waypaper
ln -s ~/.config/dotfiles/theming/Kvantum ~/.config/Kvantum
ln -s ~/.config/dotfiles/theming/nwg-look ~/.config/nwg-look
ln -s ~/.config/dotfiles/theming/qt6ct ~/.config/qt6ct
ln -s ~/.config/dotfiles/theming/.themes ~/.themes
ln -s ~/.config/dotfiles/theming/.icons ~/.icons
ln -s ~/.config/dotfiles/wal ~/.config/wal
ln -s ~/.config/dotfiles/wlogout ~/.config/wlogout
ln -s ~/.config/dotfiles/hypr ~/.config/hypr
ln -s ~/.config/dotfiles/catnap ~/.config/catnap
ln -s ~/.config/dotfiles/rofi ~/.config/rofi
ln -s ~/.config/dotfiles/waybar ~/.config/waybar

mkdir -p ~/.local/share
ln -s ~/.config/dotfiles/applications ~/.local/share/applications

# Copy additional configuration files
echo "Copying configuration files..."
cp ~/.config/dotfiles/confs/* ~/.config/

echo "Installation complete!"
