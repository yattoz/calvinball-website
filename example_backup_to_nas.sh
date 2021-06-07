#!/bin/bash
rsync -L --no-perms --no-owner --no-group -a $HOME/calvinball-website/images -e "ssh -p 37509"  user@address.server:/path/to/cvinballconsortium/
# same for audio, resources, docs
