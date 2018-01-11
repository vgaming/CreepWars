#!/bin/bash -eu
set -o pipefail
{

mkdir -p target


git describe --tags | head -c 11 | tee target/version.txt


lua build/docs_to_txt.lua > target/about.txt


}; exit 0