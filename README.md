The purpose of this repo is to make life easier for all the developers out there
It very much assumes you're using zsh, rvm, and git. There are configurations for vim, but whether you want to use vim is completely up to you. Nothing will break if you don't.

## install

- `git clone https://github.com/narshlob/zsh_ftw ~/.zsh_ftw`
- `cd ~/.zsh_ftw`
- `rake install`

The install rake task will symlink the appropriate files in `.zsh_ftw` to your
home directory. Everything is configured and tweaked within `~/.zsh_ftw`,
though.

If you're using VIM (or want to), you'll have to run a separate rake task to
install it

- `rake install:vim`

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `rake install`.

## components

Follow these conventions to get things you want in the right places

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/\*.symlink**: Any files ending in `*.symlink` get symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `rake install`.
- **vim/\*.vimlink**: Any files ending in `*.vimlink` get symlinked into
  your root directory.
- **vim/plugin/*.vim: Any files within this directory will get symlinked into
  your ~/.vim/plugin directory. Use this strictly for custom plugins you've
  created. If you want to include someone elses plugin into your vim bundles,
  add a reference to that plugin's git repo in tools/vimbundles
- **topic/\*.completion.sh**: Any files ending in `completion.sh` get loaded
  last so that they get loaded after we set up zsh autocomplete functions.

## contributors
A special thanks to those that freely provided the functions and directory structures used in this project
