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
away from installing. Please note that in `xmonad/start-xmonad.zsh` we expand the `PATH` to be able to use custom executables. You may need to modify this to your heart's content.

[dconway]: https://github.com/thoughtstream/Damian-Conway-s-Vim-Setup
[dotbot]: https://github.com/anishathalye/dotbot
[vim]: http://www.vim.org/
[xmonad]: http://xmonad.org/
[ohmyzsh]: https://github.com/robbyrussell/oh-my-zsh
[cmark]: http://commonmark.org/
