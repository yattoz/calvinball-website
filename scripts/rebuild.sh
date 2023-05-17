#!/usr/bin/env bash
PATH="$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims"
cd /home/yattoz/calvinball-website 
echo "start from schedule" > start.log
git pull 2>&1 > git.log
ruby scripts/podcast_resources.rb --rebuild 2>&1 > podcast_resources.log
ruby scripts/xmpp_ring --message="Podcast published from scheduled task"
