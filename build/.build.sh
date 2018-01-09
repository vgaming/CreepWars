#!/bin/bash -eu
set -o pipefail
{

mkdir -p target
rm target/*


version="$(git describe --tags)"
echo "$version"
sed -i -e "s/version=.*$/version=\"$version\"/" _server.pbl
echo -n "$version" > target/version.txt


# calculate text description
lua doc/docs_to_txt.lua > target/about.txt
# delete _server.pbl description
sed -i '/description=/,//d' _server.pbl
# add it back
(echo -n 'description="'; cat target/about.txt; echo '"') >> _server.pbl

}; exit 0