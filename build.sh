#!/bin/bash -eu
set -o pipefail
{

version="$(git describe --tags)"


# find-replace in _server.pbl
sed -i -e "s/version=.*$/version=\"$version\"/" _server.pbl


# update /target/version.txt
mkdir -p target
echo -n "$version" > target/version.txt


# find-replace in _main.cfg
#pattern='^[0-9a-z.-]+#enddef$'
#grep -E "$pattern" _main.cfg 1>/dev/null
#sed -i -r -e "s/$pattern/$version#enddef/" _main.cfg

}; exit 0
