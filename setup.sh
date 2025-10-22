#!/bin/bash

# Check if gum is installed, install if not
if ! command -v gum &> /dev/null; then
    echo "📦 Gum is not installed. Installing..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --needed --noconfirm gum
        echo "✓ Gum installed successfully"
    else
        echo "❌ Error: pacman not found. Please install gum manually."
        exit 1
    fi
    echo ""
fi

# Parse arguments
DRY_RUN=false
AUTO_YES=false

for arg in "$@"; do
    case $arg in
        --dry-run|-d)
            DRY_RUN=true
            ;;
        --yes|-y)
            AUTO_YES=true
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -d, --dry-run    Show what would be done without executing"
            echo "  -y, --yes        Automatically answer yes to all prompts"
            echo "  -h, --help       Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                  # Interactive installation"
            echo "  $0 --dry-run        # Preview commands with prompts"
            echo "  $0 -y               # Install everything without prompts"
            echo "  $0 --dry-run -y     # Preview all commands without prompts"
            exit 0
            ;;
    esac
done

# Show mode banners
if [ "$DRY_RUN" = true ] && [ "$AUTO_YES" = true ]; then
    gum style --border rounded --border-foreground 214 --padding "1 2" --margin "1" \
        "🔍 DRY RUN MODE + AUTO YES" \
        "All commands will be displayed" \
        "No confirmations • No execution"
elif [ "$DRY_RUN" = true ]; then
    gum style --border rounded --border-foreground 214 --padding "1 2" --margin "1" \
        "🔍 DRY RUN MODE" \
        "Commands will be displayed but not executed" \
        "You can still choose which sections to run"
elif [ "$AUTO_YES" = true ]; then
    gum style --border rounded --border-foreground 76 --padding "1 2" --margin "1" \
        "⚡ AUTO YES MODE" \
        "All steps will be executed automatically" \
        "No confirmations will be requested"
fi

# Dotfiles directory
DOTFILES_DIR="$HOME/.config/dotfiles"

# Function to handle confirmations
confirm() {
    local prompt="$1"
    if [ "$AUTO_YES" = true ]; then
        return 0  # Always return true (yes)
    else
        gum confirm "$prompt"
    fi
}

# Function to execute or display commands
run_cmd() {
    local description="$1"
    shift
    local cmd="$*"
    
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ $description"
        gum style --foreground 240 "  $ $cmd"
    else
        gum spin --spinner dot --title "$description" -- bash -c "$cmd"
    fi
}

# Function to stow packages
stow_package() {
    local package="$1"
    local description="$2"
    
    if [ "$DRY_RUN" = true ]; then
        echo "  stow -d $DOTFILES_DIR -t $HOME $package"
    else
        stow -d "$DOTFILES_DIR" -t "$HOME" "$package" 2>&1
    fi
}

# Welcome message
gum style \
    --border double \
    --border-foreground 212 \
    --padding "1 2" \
    --margin "1" \
    "🚀 Hyprland Dotfiles Installation" \
    "" \
    "This will install packages and configure your system"

echo ""

# Confirm installation
if ! confirm "Do you want to proceed with the installation?"; then
    gum style --foreground 196 "Installation cancelled"
    exit 0
fi

echo ""

# System Update and Package Installation
gum style --bold --foreground 212 "📦 Installing System Packages"
echo ""

if confirm "Install base packages with pacman?"; then
    PACMAN_PKGS="breeze-gtk python-pywal zsh eza gparted hypridle hyprland hyprlock kitty nwg-look qt6ct rofi-wayland starship thunar viu xdg-desktop-portal-hyprland wl-clipboard brightnessctl swww stow unzip git curl wget"
    
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Updating system"
        echo "  sudo pacman -Syu --noconfirm"
        gum style --foreground 214 "→ Installing pacman packages"
        echo "  sudo pacman -S --needed --noconfirm $PACMAN_PKGS"
    else
        gum spin --spinner dot --title "Updating system..." -- \
            sudo pacman -Syu --noconfirm
        gum spin --spinner dot --title "Installing pacman packages..." -- \
            sudo pacman -S --needed --noconfirm $PACMAN_PKGS
        gum style --foreground 76 "✓ Pacman packages installed"
    fi
fi

echo ""

if confirm "Install AUR packages with yay?"; then
    YAY_PKGS="bibata-cursor-theme ags-hyprpanel-git hyprshot zen-browser-bin waypaper wlogout"
    
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Installing AUR packages"
        echo "  yay -S --needed --noconfirm $YAY_PKGS"
    else
        gum spin --spinner dot --title "Installing AUR packages..." -- \
            yay -S --needed --noconfirm $YAY_PKGS
        gum style --foreground 76 "✓ AUR packages installed"
    fi
fi

echo ""

# Font Installation
gum style --bold --foreground 212 "🔤 Installing Fonts"
echo ""

if confirm "Install fonts?"; then
    FONT_PKGS="ttf-jetbrains-mono ttf-font-awesome ttf-jetbrains-mono-nerd ttf-firacode-nerd inter-font ttf-fira-code"
    
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Installing fonts from official repos"
        echo "  sudo pacman -S --needed --noconfirm $FONT_PKGS"
        gum style --foreground 214 "→ Installing Apple fonts from AUR"
        echo "  yay -S --needed --noconfirm otf-apple-fonts"
    else
        gum spin --spinner dot --title "Installing fonts from official repos..." -- \
            sudo pacman -S --needed --noconfirm $FONT_PKGS
        gum spin --spinner dot --title "Installing Apple fonts from AUR..." -- \
            yay -S --needed --noconfirm otf-apple-fonts
        gum style --foreground 76 "✓ Fonts installed"
    fi
fi

echo ""

# Oh My Zsh Installation
gum style --bold --foreground 212 "🐚 Installing Oh My Zsh"
echo ""

if confirm "Install Oh My Zsh and plugins?"; then
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Installing Oh My Zsh (unattended)"
        echo "  sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\" \"\" --unattended"
        gum style --foreground 214 "→ Installing zsh-autosuggestions plugin"
        echo "  git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        gum style --foreground 214 "→ Installing zsh-syntax-highlighting plugin"
        echo "  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    else
        # Check if Oh My Zsh is already installed
        if [ -d "$HOME/.oh-my-zsh" ]; then
            gum style --foreground 214 "⚠ Oh My Zsh is already installed, skipping"
        else
            gum spin --spinner dot --title "Installing Oh My Zsh..." -- \
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            gum style --foreground 76 "✓ Oh My Zsh installed"
        fi
        
        # Install zsh-autosuggestions
        if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
            gum style --foreground 214 "⚠ zsh-autosuggestions already installed, skipping"
        else
            gum spin --spinner dot --title "Installing zsh-autosuggestions..." -- \
                git clone https://github.com/zsh-users/zsh-autosuggestions \
                "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
            gum style --foreground 76 "✓ zsh-autosuggestions installed"
        fi
        
        # Install zsh-syntax-highlighting
        if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
            gum style --foreground 214 "⚠ zsh-syntax-highlighting already installed, skipping"
        else
            gum spin --spinner dot --title "Installing zsh-syntax-highlighting..." -- \
                git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
                "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
            gum style --foreground 76 "✓ zsh-syntax-highlighting installed"
        fi
    fi
fi

echo ""

# Extract Themes and Icons
gum style --bold --foreground 212 "🎨 Extracting Themes and Icons"
echo ""

if confirm "Extract themes and icons to home directory?"; then
    ICONS_ZIP="$DOTFILES_DIR/theming/.icons.zip"
    THEMES_ZIP="$DOTFILES_DIR/theming/.themes.zip"
    
    if [ "$DRY_RUN" = true ]; then
        if [ -f "$ICONS_ZIP" ]; then
            gum style --foreground 214 "→ Extracting icons"
            echo "  unzip -q $ICONS_ZIP -d $HOME"
        else
            gum style --foreground 214 "⚠ .icons.zip not found, skipping"
        fi
        
        if [ -f "$THEMES_ZIP" ]; then
            gum style --foreground 214 "→ Extracting themes"
            echo "  unzip -q $THEMES_ZIP -d $HOME"
        else
            gum style --foreground 214 "⚠ .themes.zip not found, skipping"
        fi
    else
        if [ -f "$ICONS_ZIP" ]; then
            gum spin --spinner dot --title "Extracting icons..." -- \
                unzip -q "$ICONS_ZIP" -d "$HOME"
            gum style --foreground 76 "✓ Icons extracted to ~/.icons"
        else
            gum style --foreground 214 "⚠ .icons.zip not found, skipping"
        fi
        
        if [ -f "$THEMES_ZIP" ]; then
            gum spin --spinner dot --title "Extracting themes..." -- \
                unzip -q "$THEMES_ZIP" -d "$HOME"
            gum style --foreground 76 "✓ Themes extracted to ~/.themes"
        else
            gum style --foreground 214 "⚠ .themes.zip not found, skipping"
        fi
    fi
fi

echo ""

# Stow Configuration Files
gum style --bold --foreground 212 "🔗 Stowing Configuration Files"
echo ""

if confirm "Stow configuration files?"; then
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Stowing configuration packages:"
    fi
    
    # Define stow packages based on your directory structure
    STOW_PACKAGES=(
        "alacritty"
        "catnap"
        "hypr"
        "hyprpanel"
        "kitty"
        "rofi"
        "starship"
        "wal"
        "waybar"
        "waypaper"
        "wlogout"
        "zsh"
    )
    
    for package in "${STOW_PACKAGES[@]}"; do
        if [ -d "$DOTFILES_DIR/$package" ]; then
            if [ "$DRY_RUN" = true ]; then
                stow_package "$package" "Stowing $package"
            else
                if stow_package "$package" "Stowing $package"; then
                    gum style --foreground 76 "  ✓ Stowed $package"
                else
                    gum style --foreground 196 "  ✗ Failed to stow $package"
                fi
            fi
        fi
    done
    
    # Stow applications to ~/.local/share/applications
    if [ -d "$DOTFILES_DIR/applications" ]; then
        if [ "$DRY_RUN" = true ]; then
            gum style --foreground 214 "→ Stowing applications"
            echo "  mkdir -p $HOME/.local/share"
            echo "  stow -d $DOTFILES_DIR -t $HOME/.local/share applications"
        else
            mkdir -p "$HOME/.local/share"
            if stow -d "$DOTFILES_DIR" -t "$HOME/.local/share" applications 2>&1; then
                gum style --foreground 76 "  ✓ Stowed applications"
            else
                gum style --foreground 196 "  ✗ Failed to stow applications"
            fi
        fi
    fi
    
    # Stow Kvantum, nwg-look, qt6ct
    if [ -d "$DOTFILES_DIR/theming/Kvantum" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "  stow -d $DOTFILES_DIR/theming -t $HOME/.config Kvantum"
        else
            if stow -d "$DOTFILES_DIR/theming" -t "$HOME/.config" Kvantum 2>&1; then
                gum style --foreground 76 "  ✓ Stowed Kvantum"
            fi
        fi
    fi
    
    if [ -d "$DOTFILES_DIR/theming/nwg-look" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "  stow -d $DOTFILES_DIR/theming -t $HOME/.config nwg-look"
        else
            if stow -d "$DOTFILES_DIR/theming" -t "$HOME/.config" nwg-look 2>&1; then
                gum style --foreground 76 "  ✓ Stowed nwg-look"
            fi
        fi
    fi
    
    if [ -d "$DOTFILES_DIR/theming/qt6ct" ]; then
        if [ "$DRY_RUN" = true ]; then
            echo "  stow -d $DOTFILES_DIR/theming -t $HOME/.config qt6ct"
        else
            if stow -d "$DOTFILES_DIR/theming" -t "$HOME/.config" qt6ct 2>&1; then
                gum style --foreground 76 "  ✓ Stowed qt6ct"
            fi
        fi
    fi
    
    if [ "$DRY_RUN" = false ]; then
        gum style --foreground 76 "✓ Configuration files stowed"
    fi
fi

echo ""

# Copy Additional Configuration Files
gum style --bold --foreground 212 "📄 Copying Additional Configuration Files"
echo ""

if confirm "Copy additional configuration files from confs/?"; then
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Copying files from dotfiles/confs/"
        echo "  cp -r $DOTFILES_DIR/confs/* $HOME/.config/"
    else
        if [ -d "$DOTFILES_DIR/confs" ]; then
            gum spin --spinner dot --title "Copying configuration files..." -- \
                cp -r "$DOTFILES_DIR/confs/"* "$HOME/.config/"
            gum style --foreground 76 "✓ Configuration files copied"
        else
            gum style --foreground 214 "⚠ No confs/ directory found, skipping"
        fi
    fi
fi

echo ""

# Change default shell to Zsh
gum style --bold --foreground 212 "🐚 Setting Default Shell"
echo ""

if confirm "Set Zsh as default shell?"; then
    if [ "$DRY_RUN" = true ]; then
        gum style --foreground 214 "→ Changing default shell to zsh"
        echo "  chsh -s \$(which zsh)"
    else
        if [ "$SHELL" != "$(which zsh)" ]; then
            gum spin --spinner dot --title "Setting Zsh as default shell..." -- \
                chsh -s "$(which zsh)"
            gum style --foreground 76 "✓ Default shell changed to Zsh"
            gum style --foreground 214 "⚠ You need to log out and back in for the shell change to take effect"
        else
            gum style --foreground 214 "⚠ Zsh is already the default shell"
        fi
    fi
fi

echo ""

# Completion message
if [ "$DRY_RUN" = true ]; then
    gum style \
        --border rounded \
        --border-foreground 214 \
        --padding "1 2" \
        --margin "1" \
        "🔍 Dry run complete!" \
        "" \
        "Review the commands above." \
        "Run without --dry-run to execute."
else
    gum style \
        --border double \
        --border-foreground 76 \
        --padding "1 2" \
        --margin "1" \
        "✨ Installation Complete! ✨" \
        "" \
        "Your Hyprland environment is configured." \
        "Log out and back in for all changes to take effect."
fi
