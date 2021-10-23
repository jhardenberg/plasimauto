#!/bin/bash

# Example script preparing a large number of plasim runs

# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. ./scripts/tools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

DIR=$(pwd)

#setup comp=ifort.epyc2 

# Common run parameters
YEARS=60
EMAIL=jost.hardenberg@polito.it
MEMORY=30M
LAUNCH=1
#EXO=1
SRADIR=/work/users/jost/pa/sra

# Perform a single experiment
#makeexp t000 param=$DIR/testpar.txt verbose=1

# Perform a series of experiments with parameters from a table
cd $DIR
n=1
npar=16
while read line; do
   if [ $n = 1 ]; then
      par=( $line )
   elif [ $n = 2 ]; then
      nl=( $line )
   else
      val=( $line )
      rm -f $DIR/par.txt
      for (( i=0 ; i<$npar; i++)); do
         echo ${par[$i]} ${nl[$i]} ${val[$(( i + 1 ))]} >> $DIR/par.txt
      done
      exp=${val[0]}
      makeexp $exp param=$DIR/par.txt verbose=1 set=NICE/icemod/0 set=NOCEAN/oceanmod/0 copy=$SRADIR 
   fi
   n=$(( $n + 1 ))
done < $DIR/partable.txt
#datamash transpose  <testpar.txt > partable.txt 
