#!/bin/bash

set -x
set -e

start_dir=$(pwd)

cd $start_dir

cpanm Dist::Zilla
dzil authordeps --missing | cpanm
dzil listdeps | cpanm
#cpanm Template YAML::XS File::Slurp DBI DBD::mysql

set +eu
set +x