## vim

### installation

`vimrc` is the vim configuration file can be copied at the root: `cp vimrc ~/.vimrc`, all files needed by plugins and themes and stuffs must be installed in a vim directory, also at the root: `mkdir ~/.vim` (see content of `vim` dir)

### dependencies

* [vundle](https://github.com/VundleVim/Vundle.vim): plugin manager, which can be used to install the following plugins
* [nerdtree](https://github.com/preservim/nerdtree): plugin, file system explorer, can be toggled with a map key (here, CTRL+'N')
* [nerdcommenter](https://github.com/preservim/nerdcommenter): plugin for commenting more efficiently! Can be toggled using the masterkey set in the vimrc (here, ' '+'c'+' ')
* [one-half-dark](https://github.com/sonph/onehalf): cute theme, some installation steps needed
* [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator#installation): for smooth navigation between vim and tmux
* [clang-format](https://github.com/rhysd/vim-clang-format/tree/master): automatic code formatting through vim with clang-format for a maximal code homogeneity experience (installing `clang-format` is required, some file copying too)

once Vundle is up and running, use `:PluginInstall` to install any plugin you added to your vimrc.

## oh-my-zsh

[install here](https://ohmyz.sh/)

can be configured with zshrc copied at the root `~/.zshrc`. Source after modification.

## tmux

```
apt-get install tmux
```

can be configured with tmux conf file copied at the root `cp tmux.conf ~/.tmux.conf`. Source after modification: `tmux source-file ~/.tmux.conf`. It features:
* pane switching between editor and multiplexer
* $PWD memory when creating new window or panning
* common buffer and vim keybindings for copying/pasting, `sudo apt install xclip` is required
