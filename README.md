.dotfiles
[![Build Status](https://travis-ci.org/lacymorrow/dotfiles.svg?branch=master)](https://travis-ci.org/lacymorrow/dotfiles)
========

> The (dot)files that make the magic happen.

Highly-opinionated, UNIX-friendly, macOS-directed

### Setup

- Clone the repo

- Github tracking is on by default

- To install Mercurial Tracking, clone the repo [hg-prompt](https://bitbucket.org/sjl/hg-prompt/) into your `/Appplications` folder. Ex: _/Applications/hg-prompt/prompt.py_

- The shell bindings are created for ZSH, and the `uber.zsh-theme` is included to theme [robbyrussel/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

- Finally, to install all the bindings, aliases, etc, run `./.osx` or `sh .osx`. _add the `--verbose` param optionally._

### Usage

`git fuck` is my most used alias (aliased to `git reset HEAD --hard`)

This package works on any \*nix-based system, partially on windows

### Extras

Don't forget screensavers! I like the [Google Trends](https://www.google.com/trends/hottrends/visualize) personally.

- Homebrew, Node, etc...
- _From [Sindré](https://github.com/sindresorhus/quick-look-plugins):_ `brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package quicklookase qlvideo`

## Quick start

- Clone or download this repo into cd ~/dotfiles
- `chmod +x bootstrap.sh`
- `./bootstrap.sh`

> Shamelessly influenced by [mplacona](https://github.com/mplacona/dotfiles)
