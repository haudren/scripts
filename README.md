Dotfiles
========
These are my dotfiles, even though the repository is not well named.

Contents
--------
* [VIM][vim]: I know, I still use pyflakes. I also use some of [Damien Conway's tricks][dconway] to make my life better.
* [XMonad][xmonad]: The only thing here is that I use two configs, one for single-monitor setup and one for dual monitor setup, along with a bunch of custom executables.
* [Oh-My-Zsh][ohmyzsh]: Guilty as charged, I love Oh-My-Zsh, especially with a custom theme.
* A small note modules that reads/writes notes in your `$HOME/notes`, requires [cmark][cmark] to be in your `$PATH` and `$EDITOR` to be set (for example in your zshrc)

Install
-------
I use [Dotbot][dotbot] to manage installation of my configuration. Everything should just be a 
```
./install
```
away from installing. Unfortunately, I could not yet add direct support for linking in a protected directory, so you will have to manually link "change_volume" and "xcalendar" to your PATH i.e.
```
sudo ln -s change_volume /usr/bin/change_volume
```
(This is because xmonad spawns commands in a default shell that does not seem to be the same as my current setup, and I went for the only place I was sure xmonad would find the executable). If you do not want to use this quick fix, simply drop back to using `amixer` directly in `xmonad.hs` and remove date widget.

[dconway]: https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
[dotbot]: https://github.com/anishathalye/dotbot
[vim]: http://www.vim.org/
[xmonad]: http://xmonad.org/
[ohmyzsh]: https://github.com/robbyrussell/oh-my-zsh
[cmark]: http://commonmark.org/
