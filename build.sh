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


# export git log
#git log --date=short -10 --pretty='%ad %cn %d %s' > doc/git_changelog.txt


# delete _server.pbl description
sed -i '/description=/,//d' _server.pbl
# add it back
echo -n 'description="' >> _server.pbl
lua doc/documentation_os_extractor.lua > target/about.html
lua doc/documentation_os_extractor.lua >> _server.pbl
echo '"' >> _server.pbl

}; exit 0