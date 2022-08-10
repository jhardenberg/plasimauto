#!/bin/bash
set -ex
# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. scripts/posttools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

#setup comp=ifort.epyc2

EMAIL=jost.hardenberg@polito.it
MEMORY=500M
LAUNCH=1

VARS="tas al sic clt pr"
DIR=$(pwd)
OUTFILE=$DIR/post_lsg.txt
y1=1901
y2=2000
y1=121
y2=170

cd $EXPDIR

for DEPTH in 0050 0100 0250 0500 1000 2000 3000 4000
do
#   for s in 0.9 1.1
   for s in 1.0
   do
      for t in c h
      do
         fn=lsg${DEPTH}_s${s}_${t}
         for var in $VARS
         do
            echo Postprocessing $fn $var
            post $fn $var $y1 $y2
         done
      done
   done
done
