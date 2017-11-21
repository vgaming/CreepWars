#!/bin/bash -eu
set -o pipefail
{

version="$(git describe --tags)"
echo "$version"


# find-replace in _server.pbl
sed -i -e "s/version=.*$/version=\"$version\"/" _server.pbl


# update /target/version.txt
mkdir -p target
echo -n "$version" > target/version.txt


# strip out html tags
description="$(lua doc/documentation_os_extractor.lua | sed -e 's/<[^>]*>//g')"
# delete _server.pbl description
sed -i '/email/,$!d' _server.pbl
# compose _server.pbl back
printf '%s\n\n%s\n"\n%s' '
# THIS FILE IS EDITED by build.sh

author="Vasya Novikov, Blitzmerker, piezocuttlefish"
description="Upgrade your leader and fight for victory.' "$description" "$(cat _server.pbl)" > _server.pbl

}; exit 0
