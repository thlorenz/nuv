#!/usr/bin/env sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR/build &&    \
rm -rf * &&         \
make -C .. ln_$1 && \
cmake .. &&         \
make 
