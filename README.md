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

Install npm dependencies:
```
npm install
```

Install ruby dependencies:
```
bundle
```

Run
```
npm run docs:dev
```
