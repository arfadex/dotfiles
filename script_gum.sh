#!/bin/bash

# Ensure gum is installed
if ! command -v gum &> /dev/null; then
    echo "gum is not installed. Installing gum..."
    sudo pacman -S --needed --noconfirm gum
fi

# Update system and install packages
gum spin --spinner dot --title "🚀 Installing required packages..." -- sudo pacman -Syu --noconfirm &> /dev/null
gum spin --spinner dot --title "📦 Installing essential packages..." -- sudo pacman -S --needed --noconfirm \
  breeze-gtk python-pywal zsh eza gparted hypridle hyprland hyprlock kitty nwg-look \
  qt6ct rofi-wayland starship thunar viu \
  xdg-desktop-portal-hyprland wl-clipboard brightnessctl swww &> /dev/null

gum spin --spinner dot --title "📦 Installing AUR packages..." -- yay -S --needed --noconfirm \
  bibata-cursor-theme ags-hyprpanel-git hyprshot waypaper wlogout &> /dev/null

# Install fonts
gum spin --spinner dot --title "🔤 Installing fonts..." -- sudo pacman -S --needed --noconfirm \
  ttf-jetbrains-mono ttf-font-awesome ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd inter-font ttf-fira-code &> /dev/null

gum spin --spinner dot --title "🔤 Installing additional fonts..." -- yay -S --needed --noconfirm otf-apple-fonts &> /dev/null

# Create symbolic links
gum spin --spinner dot --title "🔗 Creating symbolic links..." -- bash -c '
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
' &> /dev/null

# Copy additional configuration files
gum spin --spinner dot --title "📂 Copying configuration files..." -- cp ~/dotfiles/confs/* ~/.config/ &> /dev/null

# Clone wallpapers
gum spin --spinner dot --title "🖼️ Cloning wallpapers..." -- git clone --depth 1 https://github.com/arfadex/wallpapers ~/Pictures/wallpapers &> /dev/null

# Completion message
gum style --border double --margin "1" --padding "1" --border-foreground 46 "✅ Installation complete!"
