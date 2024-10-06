#!/bin/bash
echo "Content-type: text/json"
echo ""
CONTENT="$(ls -t /calvinballconsortium/images/$PODCAST_KEY/full/*.* | sed -e "s/^/\"/g" | sed -e "s|$|\",|g")"
echo "[${CONTENT::-1}]"
