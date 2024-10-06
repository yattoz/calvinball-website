#!/bin/bash
echo "Content-type: text/json"
echo ""
CONTENT="$(find /calvinballconsortium/audio/$PODCAST_KEY/*.* | sed -e "s/^/\"/g" | sed -e "s|$|\",|g")"
echo "[${CONTENT::-1}]"
