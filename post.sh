#!/bin/bash
#set -ex
. scripts/posttools.sh

cd $EXPDIR
for fn in ees??????t?
do
    echo Postprocessing $fn
    post $fn tas 31/60
    post $fn sic 31/60
    post $fn sit 31/60
    post $fn al 31/60
    post $fn pr 31/60
done

