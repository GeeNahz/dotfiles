# My dotfiles

This directory contains some of my dotfile configurations.

## Requirements

Ensure you have the following installed on your system:

#### Git

```
sudo apt install git
```

#### Stow

```
sudo apt install stow
```

## Download

First, check out the dotfiles repo in your $HOME directory using git:

```
git clone git@github.com:GeeNahz/dotfiles.git ~/dotfiles
```

## Setup

#### Fonts
Create symlinks to the tmux configuration file:

```
cd ~/dotfiles
stow fonts
```

#### Zsh
Install zsh using your distro's package manager:

```
sudo apt install zsh
```

Make zsh the default shell:
```
chsh -s $(which zsh)
```

Use stow to create symlinks for zsh files:

```
cd ~/dotfiles
stow zsh
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
sudo apt install nvim
```

Use stow to create symlinks for the neovim config files:

```
cd ~/dotfiles
stow nvim
```

Open your terminal and launch Neovim with the ```nvim``` command.

#### Alacritty
Install alacritty using your distro's package manager:

```
sudo apt install alacritty
```
If it's not available in your package manager repository, visit alacritty's [official website](https://alacritty.org/) to find out how to install it for your distro.

Create symlinks to the alacritty configuration files:

```
cd ~/dotfiles
stow alacritty
```

#### Tmux
Install tmux using your distro's package manager:

```
sudo apt install tmux
```

Create symlinks to the tmux configuration file:

```
cd ~/dotfiles
stow tmux
```

Open your terminal and launch tmux by typing ```tmux```.

Clone the Tmux Plugin Manager (tpm):

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Restart tmux and press ```prefix``` + <kbd>I</kbd> to fetch the defined plugins.

#### Picom

#### Polybar

#### i3

#### backgrounds
- install feh
