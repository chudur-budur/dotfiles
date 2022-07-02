# dotfiles

Dotfiles for `~`

**Contents:**
* `bash`: `~/.bash` mirror.
* `emacs.d`: `~/.emacs.d` mirror.
* `fonts`: `~/.fonts` mirror.
* `ssh`: `~/.ssh` mirror.
* `task`: `~/.task` mirror **(hardly used)**.
* `vim`: `~/.vim` folder mirror.
* `Xdefaults`: `~/.Xdefaults` mirror.
* `alacritty.yml`: `alacritty` configs.
* `bash_aliases`: `~/.bash_aliases` mirror.
* `bashrc`: `~/.bashrc` mirror.
* `emacs`: `~/.emacs` mirror.
* `git-completion.bash`: git command auto completion.
* `gitconfig`: `~/.gitconfig` mirror.
* `gitignore_global`: `~/.gitingore_global` mirror.
* `gmu`: GMU compute cluster settings.
* `msu`: MSU server settings.
* `msuhpcc`: I use it only for the msu hpcc account, basically a reduced version of `myenv`.
* `myenv`: custom bash environment and stuffs.
* `info`: misc infos.
* `nod`: Nod Inc. compute cluster settings.
* `nokia`: Nokia Bell Labs compute cluster settings.
* `npmrc`: node.js settings.
* `sentient`: sentient.ai LLC compute cluster settings.
* `taskrc`: `~/.taskrc` mirror **(hardly used, deprecated)**.
* `theanorc`: `theano` settings **(I guess no one uses it anymore)**.
* `vimrc`: self explanatory

# Usage
```bash
git clone git@github.com:chudur-budur/dotfiles.git .dotfiles
cd .dotfiles
git submodule update --init --recursive
```
Then make the symlinks --
```bash
cd ~
ln -sf .dotfiles/bashrc .bashrc
ln -sf .dotfiles/bash_aliases .bash_aliases
```
and so on.
