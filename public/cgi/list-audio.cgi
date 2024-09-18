#!/bin/bash
echo "Content-type: text/json"
echo ""
CONTENT="$(find /calvinballconsortium/audio/*/*.* | sed -e "s/^/\"/g" | sed -e "s|$|\",|g")"
echo "[${CONTENT::-1}]"