#!/bin/bash
set -ex
# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. scripts/tools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

#setup comp=ifort.epyc2

# Common run parameters
YEARS=2000
EMAIL=jost.hardenberg@polito.it
MEMORY=30M
LAUNCH=1
EXO=1

SOLC=1361
CO2LEV=360
for DEPTH in 0050 0100 0250 0500 1000 2000 3000 4000
do
makeexp lsg${DEPTH}_s1.0_c s0=$SOLC ecc=0.0 obl=0.0 co2=$CO2LEV tgr=230 lsg=$DEPTH aqua=1
makeexp lsg${DEPTH}_s1.0_h s0=$SOLC ecc=0.0 obl=0.0 co2=$CO2LEV tgr=320 lsg=$DEPTH aqua=1
#makeexp lsg${DEPTH}_s1.1_c s0=1497.1 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=230 lsg=$DEPTH aqua=1
#makeexp lsg${DEPTH}_s1.1_h s0=1497.1 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=320 lsg=$DEPTH aqua=1
#makeexp lsg${DEPTH}_s0.9_c s0=1224.9 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=230 lsg=$DEPTH aqua=1
#makeexp lsg${DEPTH}_s0.9_h s0=1224.9 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=320 lsg=$DEPTH aqua=1
done
DEPTH=0500
makeexp lsg${DEPTH}_s1.1_c s0=1497.1 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=230 lsg=$DEPTH aqua=1
makeexp lsg${DEPTH}_s1.1_h s0=1497.1 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=320 lsg=$DEPTH aqua=1
makeexp lsg${DEPTH}_s0.9_c s0=1224.9 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=230 lsg=$DEPTH aqua=1
makeexp lsg${DEPTH}_s0.9_h s0=1224.9 ecc=0.0 obl=0.0 co2=$CO2LEV tgr=320 lsg=$DEPTH aqua=1

