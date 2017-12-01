#!/bin/bash -eu
set -o pipefail
{

version="$(git describe --tags)"
echo "$version"


# find-replace in _server.pbl
sed -i -e "s/version=.*$/version=\"$version\"/" .server.pbl


# update /target/version.txt
mkdir -p target
echo -n "$version" > target/version.txt


# export git log
#git log --date=short -10 --pretty='%ad %cn %d %s' > doc/git_changelog.txt


# create server.pbl files
cp .server.pbl target/.server12.pbl
cp .server.pbl target/.server13.pbl

lua doc/documentation_os_extractor.lua >> target/.server13.pbl
lua doc/documentation_os_extractor.lua | sed -e 's/<[^>]*>//g' >> target/.server12.pbl

echo '"' >> target/.server12.pbl
echo '"' >> target/.server13.pbl

}; exit 0
