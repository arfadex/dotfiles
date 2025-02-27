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
ln -s ~/dotfiles/kitty ~/.config/kitty
ln -s ~/dotfiles/starship/starship.toml ~/.config/starship.toml
ln -s ~/dotfiles/waypaper ~/.config/waypaper
ln -s ~/dotfiles/theming/Kvantum ~/.config/Kvantum
ln -s ~/dotfiles/theming/nwg-look ~/.config/nwg-look
ln -s ~/dotfiles/theming/qt6ct ~/.config/qt6ct
ln -s ~/dotfiles/theming/.themes ~/.themes
ln -s ~/dotfiles/theming/.icons ~/.icons
ln -s ~/dotfiles/wal ~/.config/wal
ln -s ~/dotfiles/wlogout ~/.config/wlogout
ln -s ~/dotfiles/hypr ~/.config/hypr
ln -s ~/dotfiles/catnap ~/.config/catnap
ln -s ~/dotfiles/rofi ~/.config/rofi
ln -s ~/dotfiles/waybar ~/.config/waybar

mkdir -p ~/.local/share
ln -s ~/dotfiles/applications ~/.local/share/applications

# Copy additional configuration files
echo "Copying configuration files..."
cp ~/dotfiles/confs/* ~/.config/

# Install Oh My Zsh and plugins
echo "Installing Oh My Zsh..."
sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Replace default .zshrc with custom one
echo "Setting up Zsh configuration..."
rm -f ~/.zshrc
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc

# Clone wallpapers
echo "Cloning wallpapers..."
git clone --depth 1 https://github.com/arfadex/wallpapers ~/Pictures/wallpapers

echo "Installation complete!"
