# Dotfiles

## Programs

### Window Management and Display
- **Window Manager** 🪟: [Hyprland](https://github.com/hyprwm/Hyprland)
- **Status Bar** 📊: [Hyprpanel](https://github.com/Jas-SinghFSU/HyprPanel)
- **App Launcher** 🚀: [Rofi](https://github.com/davatorium/rofi)
- **Login Manager** 🏦: [SDDM](https://github.com/sddm/sddm)
- **Lockscreen** 🔒: [Hyprlock](https://github.com/hyprwm/hyprlock)

### Terminal and Shell
- **Terminal** 🖥️: [Kitty](https://github.com/kovidgoyal/kitty)
- **Shell** 🐚: [Zsh](https://github.com/zsh-users/zsh)

### Utilities and Tools
- **Fetch Utility** 🎨: [Catnip](https://github.com/iinsertNameHere/catnip)
- **File Manager** 📁: [Thunar](https://gitlab.xfce.org/xfce/thunar)
- **Editor** 🖋️: [VS Code](https://code.visualstudio.com/)
- **Browser** 🌐: [Firefox](https://www.mozilla.org/firefox/)

## Packages

### Installed via `pacman`:

```bash
sudo pacman -S --needed \
  breeze-gtk zsh eza python-pywal gparted hypridle hyprland hyprlock kitty nwg-look \
  qt6ct rofi-wayland starship thunar catnip viu \
  xdg-desktop-portal-hyprland wl-clipboard brightnessctl swww
```

### Installed via `yay`:

```bash
yay -S --needed \
  bibata-cursor-theme ags-hyprpanel-git hyprshot waypaper wlogout
```

## Fonts

### Installed via `pacman`:

```bash
sudo pacman -S --needed \
  ttf-jetbrains-mono ttf-font-awesome ttf-jetbrains-mono-nerd \
  ttf-firacode-nerd inter-font ttf-fira-code
```

### Installed via `yay`:

```bash
yay -S otf-apple-fonts
```

## Installation

### Clone the Repository

```bash
git clone --depth 1 https://github.com/arfadex/dotfiles.git
cd dotfiles
```

### Run the Setup Script

```bash
chmod +x setup.sh
./setup.sh
```

### Install Zsh Plugins

1. Install **Oh My Zsh**:

   ```bash
   sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
   ```

2. Add plugins:

   - **zsh-autosuggestions**:

     ```bash
     git clone https://github.com/zsh-users/zsh-autosuggestions \
       ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
     ```

   - **zsh-syntax-highlighting**:

     ```bash
     git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
       ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
     ```
