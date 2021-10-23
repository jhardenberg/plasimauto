#!/bin/bash
#set -ex

# Complex example using the "post" command to extract a table of fluxes

. ./scripts/posttools.sh

LC_NUMERIC="en_US.UTF-8"

y1=31
y2=40
DIR=$(pwd)
OUTFILE=$DIR/post.txt
VARS="rls rss hfls hfss ssru stru rst net"

echo "#EXP $VARS" > $OUTFILE

cd $EXPDIR
for fn in h0??
do
    printf "%s " $fn >> $OUTFILE
    for var in $VARS
    do
       echo Postprocessing $fn $var
       post $fn $var $y1/$y2
       printf "%f " $(cat ${fn}_${var}_fld_clim.txt) >> $OUTFILE
    done
    printf "\n" >> $OUTFILE
done
