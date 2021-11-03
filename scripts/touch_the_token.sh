#!/bin/bash
CUR_DIR=`dirname "$(readlink -f "$0")"`
touch "$CUR_DIR/../generation_token/token"
