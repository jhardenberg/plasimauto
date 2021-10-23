#!/bin/bash

# Example script preparing a large number of exoplanetary runs

# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. ./scripts/tools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

#setup comp=ifort.epyc2 

# Common run parameters
YEARS=60
EMAIL=jost.hardenberg@polito.it
MEMORY=30M
LAUNCH=0
#EXO=1

DIR=$(pwd)
makeexp t000 param=$DIR/testpar.txt verbose=1
