#!/bin/bash

set -x
set -e

start_dir=$(pwd)

VRCODEBASE_GIT_URL='https://github.com/sanger-pathogens/vr-codebase.git'
FASTQCHECK_GIT_URL='https://github.com/sanger-pathogens/fastqcheck.git'

# Make an install location
if [ ! -d 'git_repos' ]; then
  mkdir git_repos
fi
cd git_repos

git clone $VRCODEBASE_GIT_URL
git clone $FASTQCHECK_GIT_URL

#Add lovations to PERL5LIB
VRCODEBASE_LIB=${start_dir}'/git_repos/vr-codebase/modules'

export PERL5LIB=${VRCODEBASE_LIB}:$PERL5LIB

#Install fastqcheck
cd fastqcheck
autoreconf -i -f
./configure
make
sudo make install

cd $start_dir

cpanm Dist::Zilla Dist::Zilla::Plugin::Test::Compile
dzil authordeps --missing | cpanm
dzil listdeps | cpanm
cpanm File::Slurp DBI XML::TreePP Bio::DB::EUtilities Parallel::ForkManager Spreadsheet::ParseExcel Test::MockObject Time::Format DBD::mysql YAML::XS IO::Capture::Stderr
export LD_LIBRARY_PATH=/usr/local/lib

#Template

set +eu
set +x
