# My dotfiles

This directory contains some of my dotfile configurations.

## Requirements

Ensure you have the following installed on your system:
> [!NOTE]
> Some commands used here are perculiar to Arch Linux (btw). Please refer to the commands that are perculiar to your Linux/Unix distro in case of any conflict.

#### Git

```
sudo pacman -S git
```

#### Stow

```
sudo pacman -S stow
```

#### gcc

```
sudo pacman -S gcc
```

#### ripgrep

```
sudo pacman -S ripgrep
```

#### node and npm

```
sudo pacman -S nodejs npm
```

## Download

First, check out the dotfiles repo in your $HOME directory using git:

```
git clone git@github.com:GeeNahz/dotfiles.git ~/dotfiles
```

## Setup

> [!NOTE]
> All commands here will be executed from the ```~/dotfiles``` dir.
> Ensure to ```cd ~/dotfiles``` before proceeding.

> I have remapped my navigations (<kbd>←</kbd> <kbd>↑</kbd> <kbd>↓</kbd> <kbd>→</kbd>) for i3, nvim, tmux, and I think alacritty to mirror that of vim motions key (<kbd>h</kbd> <kbd>j</kbd> <kbd>k</kbd> <kbd>l</kbd>) respectively.
#### Fonts
Create symlinks to the tmux configuration file:

```
sudo stow fonts
```

#### Zsh
Install zsh using your distro's package manager:

```
sudo pacman -S zsh
```

Make zsh the default shell:
```
sudo chsh -s $(which zsh)
```

Use stow to create symlinks for zsh files:

```
sudo stow zsh
```

> [!IMPORTANT]
> At times doing this fails especially when the files already exists. To enforce the changes (applicable to every stow command here), use the ```--adopt``` flag.

> [!CAUTION]
>Note: Use this with caution as this will overwrite any existing files. Ensure you back up any conflicting files first. 
>```
>stow --adopt zsh
>```

Restart the terminal to start using zsh.

#### Neovim
Install neovim with version >= v0.9.5 using your distro's package manager. If the package manager repository does not have the latest version, you can get the latest version (for most Linux package) from an [AppImage](https://github.com/neovim/neovim/blob/master/INSTALL.md#appimage-universal-linux-package) in their GitHub repo.

> [!IMPORTANT]
> Before installing Neovim, ensure you have a C compiler, Node, Npm, and a Nerd font installed. I personally use Jetbrains Mono which is the font in the fonts dotfiles above.

```
sudo pacman -S nvim
```

Use stow to create symlinks for the neovim config files:

```
sudo stow nvim
```

Open your terminal and launch Neovim with the ```nvim``` command.

Setup codeium by typing ```:Codeium Auth``` in your terminal and in the prompt, you will be prompted to enter your codeium api key.

#### Alacritty
Install alacritty using your distro's package manager:

```
sudo pacman -S alacritty
```
If it's not available in your package manager repository, visit alacritty's [official website](https://alacritty.org/) to find out how to install it for your distro.

Create symlinks to the alacritty configuration files:

```
sudo stow alacritty
```

#### Tmux
Install tmux using your distro's package manager:

```
sudo pacman -S tmux
```

Create symlinks to the tmux configuration file:

```
sudo stow tmux
```

Open your terminal and launch tmux by typing ```tmux```.

Clone the Tmux Plugin Manager (tpm):

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Restart tmux and press ```prefix``` + <kbd>I</kbd> to fetch the defined plugins.

#### i3
i3 is a Window Manager.

Install it using the i3-wm package manager.

```sh
sudo pacman -S i3-wm
```

And as usual, symlink the config file from the dotfiles dir.

```sh
sudo stow i3
```

#### Picom
Picom is a window compositor for Window Managers (e.g. i3) that do not provide compositing. Essentially, it helps to prevent screen tearing while switching i3 windows.

Install picom using your package manager repository
```sh
sudo pacman -S picom
```

Create symlink using stow

```sh
sudo stow picom
```

#### Polybar
Polybar is a nice, highly customizable status bar for desktop environment. And it's really easy to setup too. I used a pre-defined theme but feel free to customize yours however you feel like.

Install Polybar
```sh
sudo pacman -S polybar
```

Create the configuration file using stow

```sh
sudo stow polybar
```

Logout and log back in to the i3 desktop to properly get everything up and running.

#### Backgrounds
To setup background on the i3 window manager, I use feh, a lightweight image viewer mainly for users of command line interfaces.

But first, use stow to symlink the image in the backgrounds dir which will create a backgrounds symlink within ```~/.config/```. Feel free to put your own desired wallpaper there.

```sh
sudo stow backgrounds
```

Next, go ahead and install feh.
> [!NOTE]
> I use an AUR package called ```yay``` in arch linux so check to ensure it is available in your package manager's repo or check [here](https://feh.finalrewind.org/) for download instructions.

```sh
sudo yay -S feh
```

The command to run feh to setup a wallpaper is already in the i3 config file found in ```~/dotfiles/i3/.config/i3/config``` line 19.

> Remember to change the name of the wallpaper to the wallpaper that was placed in the backgrounds symlink if yours was change. Else, you can leave it as is.

Restart i3 using <span style="color: teal;">$mod</span>+r

> <span style="color: teal;">$mod</span> is the windows or <kbd>alt</kbd> key depending on what was chosen when setting up i3.

#### Rofi
Rofi is a window switcher, application launcher, and ssh-launcher, that can act as a replacement for dmenu that comes with 13-wm.

Install rofi.
> [!NOTE]
> Again, I use ```yay``` to install this package.

```sh
sudo yay -S rofi
```

Setup the config using stow
```sh
sudo stow rofi
```

I have the configurations setup for rofi in i3 config by binding rofi to <span style="color:teal;">$mod</span>+Space.


#### Emoji
Using yay, install emote, a modern emoji picker for Linux. Install it from aur

```sh
yay -S emote
```
To select an emoji, the default keyboard shortcut is `Ctrl+Alt+E`. The keybinding for this has already been setup in the hyprland.config file. Ensure to do this for other window managers or display managers.


#### Starship
Install starship using your package manager:

```sh
yay -S starship
```

Update the zshrc file to load starship. Paste this at the end of the file if it's not already there:

```sh
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"
```

Setup starship using stow:

```sh
sudo stow starship
```
