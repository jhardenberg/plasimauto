#!/bin/bash

# Example script demonstration resolution selection

# set -ex
# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. ../scripts/tools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

#setup comp=ifort.epyc2

# Common run parameters
YEARS=1
EMAIL=jost.hardenberg@polito.it
MEMORY=30M
LAUNCH=0

EXO=1
makeexp test21e res=t21 nlev=15
makeexp test31e res=t31 nlev=15
makeexp test42e res=t42 nlev=15 
makeexp test42lsg res=t42 nlev=15 lsg=1 aqua=1

EXO=0
makeexp test21 res=t21 nlev=10
makeexp test31 res=t31 nlev=10
makeexp test42 res=t42 nlev=10
