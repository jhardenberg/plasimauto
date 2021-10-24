#!/bin/bash

# Example script preparing a large number of exoplanetary runs

# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. ./scripts/tools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

DIR=$(pwd)
#setup comp=ifort.epyc2 
cd $DIR

# Common run parameters
YEARS=60
EMAIL=jost.hardenberg@polito.it
MEMORY=30M
LAUNCH=0
#EXO=1

# This is classic run with slab ocean
makeexp t000 param=$DIR/testpar.txt verbose=1

# An AMIP run with specified sra files copied from a directory
SRADIR=/home/jost/work/pa/sra
makeexp t001 param=$DIR/testpar.txt verbose=1 set=NICE/icemod/0 set=NOCEAN/oceanmod/0 copy=$SRADIR

