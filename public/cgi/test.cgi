#!/bin/bash

echo "<html>"
echo "<head>"
echo "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
echo "<title>Bash CGI script</title>"
echo "</head>"
echo "<body>"
echo "<p>Hello, Your IP address is \$REMOTE_ADDR</p>"
echo "<pre>"
env
echo "</pre>"
echo "</body>"
echo "</html>"

#!/usr/bin/env python3

# print("Content-type: text/json\n")
# print("it works in Python!")

