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

}; exit 0
