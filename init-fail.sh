#!/bin/sh

# trigger malware
wget -O /tmp/myfile https://wildfire.paloaltonetworks.com/publicapi/test/elf

# trigger dropper
wget -O /tmp/hello_world https://github.com/yeukb/misc/raw/master/hello_world && \
chmod +x /tmp/hello_world && \
/tmp/hello_world

# trigger modified binary and modified binary execution
wget -O /usr/bin/curl https://github.com/moparisthebest/static-curl/releases/download/v7.78.0/curl-amd64 && \
chmod +x /usr/bin/curl && \
curl -V

# start nginx
nginx -g "daemon off;"
