#!/bin/bash -eu
set -o pipefail
{

mkdir -p target


git describe --tags | tee target/version.txt


lua build/docs_to_txt.lua > target/about.txt


}; exit 0