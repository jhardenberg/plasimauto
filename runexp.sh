#!/bin/bash
set -ex
# This sets up all the needed functions
# Remember to set the current path in the config.sh script first
. scripts/tools.sh

# The following downloads and configures Plasim automatically.
# Needed only once, can be commented for later runs
# The optional argument comp=string will copy customized compiler options 
# from template/most_compiler.string

setup comp=ifort.wilma

# Common run parameters
YEARS=60
EMAIL=jost.hardenberg@polito.it
MEMORY=30M
LAUNCH=0

makeexp ees100e00t0 s0=1367.0 obl=0.0 co2=360 tgr=220 
makeexp ees100a00t0 s0=1367.0 obl=0.0 co2=360 tgr=220 aqua=1 
makeexp ees100a45t0 s0=1367.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45
#makeexp ees095e00t0 s0=1298.0 obl=0.0 co2=360 tgr=220 
#makeexp ees095a00t0 s0=1298.0 obl=0.0 co2=360 tgr=220 aqua=1 
#makeexp ees095a45t0 s0=1298.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45
#makeexp ees090e00t0 s0=1230.0 obl=0.0 co2=360 tgr=220 
#makeexp ees090a00t0 s0=1230.0 obl=0.0 co2=360 tgr=220 aqua=1 
#makeexp ees090a45t0 s0=1230.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45
#makeexp ees085e00t0 s0=1162.0 obl=0.0 co2=360 tgr=220 
#makeexp ees085a00t0 s0=1162.0 obl=0.0 co2=360 tgr=220 aqua=1 
#makeexp ees085a45t0 s0=1162.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45
#makeexp ees105e00t0 s0=1435.0 obl=0.0 co2=360 tgr=220 
#makeexp ees105a00t0 s0=1435.0 obl=0.0 co2=360 tgr=220 aqua=1 
#makeexp ees105a45t0 s0=1435.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45
#makeexp ees110e00t0 s0=1503.0 obl=0.0 co2=360 tgr=220 
#makeexp ees110a00t0 s0=1503.0 obl=0.0 co2=360 tgr=220 aqua=1 
#makeexp ees110a45t0 s0=1503.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45
#makeexp ees115e00t0 s0=1572.0 obl=0.0 co2=360 tgr=220 
#makeexp ees115a00t0 s0=1572.0 obl=0.0 co2=360 tgr=220 aqua=1 
#makeexp ees115a45t0 s0=1572.0 obl=0.0 co2=360 tgr=220 aqua=1 eq=45

makeexp ees100e00t1 s0=1367.0 obl=0.0 co2=360 tgr=320
makeexp ees100a00t1 s0=1367.0 obl=0.0 co2=360 tgr=320 aqua=1
makeexp ees100a45t1 s0=1367.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45
#makeexp ees095e00t1 s0=1298.0 obl=0.0 co2=360 tgr=320
#makeexp ees095a00t1 s0=1298.0 obl=0.0 co2=360 tgr=320 aqua=1
#makeexp ees095a45t1 s0=1298.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45
#makeexp ees090e00t1 s0=1230.0 obl=0.0 co2=360 tgr=320
#makeexp ees090a00t1 s0=1230.0 obl=0.0 co2=360 tgr=320 aqua=1
#makeexp ees090a45t1 s0=1230.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45
#makeexp ees085e00t1 s0=1162.0 obl=0.0 co2=360 tgr=320
#makeexp ees085a00t1 s0=1162.0 obl=0.0 co2=360 tgr=320 aqua=1
#makeexp ees085a45t1 s0=1162.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45
#makeexp ees105e00t1 s0=1435.0 obl=0.0 co2=360 tgr=320 
#makeexp ees105a00t1 s0=1435.0 obl=0.0 co2=360 tgr=320 aqua=1 
#makeexp ees105a45t1 s0=1435.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45
#makeexp ees110e00t1 s0=1503.0 obl=0.0 co2=360 tgr=320 
#makeexp ees110a00t1 s0=1503.0 obl=0.0 co2=360 tgr=320 aqua=1 
#makeexp ees110a45t1 s0=1503.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45
#makeexp ees115e00t1 s0=1572.0 obl=0.0 co2=360 tgr=320 
#makeexp ees115a00t1 s0=1572.0 obl=0.0 co2=360 tgr=320 aqua=1 
#makeexp ees115a45t1 s0=1572.0 obl=0.0 co2=360 tgr=320 aqua=1 eq=45


