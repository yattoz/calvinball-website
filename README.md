# calvinball-website
A static website for calvinball built with VuePress.

# Install

Debian, Ubuntu: use the bootstrap scripts.
- run `bootstrap_root.sh` as root, it will install npm, dependencies for rbenv, and some binary dependencies
- run `bootstrap_user.sh` as user, it will install rbenv, ruby, and get all rependencies for you.

If you don't or cant, install by hand:

- Install nodejs LTS, ruby 3 (should work with 2.6 but 3 is recommended!)
- imagemagick
- pngquant 


Install ruby dependencies:
```
bundle
```

Run
```
bundle exec ruby script/podcast_resources.rb
```

Options:

- --localserve : output directory is set to be hosted on localhost/
- --dev : output directory is set to be hosted on dev.calvinballconsortium.fr
- --rebuild: output directory is set to be hosted on www.calvinballconsortium.fr
- --noring: doesn't make my phone ring through XMPP
- --nodownload: disable all downloads and resources (audio, images) will point to remote sources

More options are available, check with -h or --help.
