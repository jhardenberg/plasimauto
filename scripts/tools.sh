#!/bin/bash
set -ex

. scripts/config.sh

replmost () {
	sed -i "s%$1%$2%g" $SRCDIR/most.cfg
}
repl () {
	sed -i "s%$1%$2%g" $3
}
insert () {
	sed -i "/^ \/END.*/i $1" $2
}
head () {
	sed -i "1c$1" $2
}

makejob () {
	EXP=$1
        mkdir -p $JOBDIR
        mkdir -p $LOGDIR
	cp $SCRIPTDIR/template/template.job $JOBDIR/$EXP.job
        repl "<exp>" $EXP $JOBDIR/$EXP.job
        repl "<email>" $EMAIL $JOBDIR/$EXP.job
        repl "<mem>" $MEMORY $JOBDIR/$EXP.job
        repl "<basedir>" $BASEDIR $JOBDIR/$EXP.job
        repl "<logdir>" $LOGDIR $JOBDIR/$EXP.job
        repl "<obliq>" $OBL $JOBDIR/$EXP.job
        repl "<eccen>" $ECC $JOBDIR/$EXP.job
        repl "<gsol0>" $GSOL0 $JOBDIR/$EXP.job
        repl "<tgr>" $TGR $JOBDIR/$EXP.job
        repl "<co2>" $CO2 $JOBDIR/$EXP.job
        repl "<hdiff>" $DIFF $JOBDIR/$EXP.job
        repl "<eq>" $EQ $JOBDIR/$EXP.job
        repl "<aqua>" $AQUA $JOBDIR/$EXP.job
        repl "<sic>" $SIC $JOBDIR/$EXP.job
  
        if [ $LAUNCH -eq 1 ]; then 
            sbatch $JOBDIR/$EXP.job
        fi
}

makeexp() {
cd $SRCDIR

EXP=$1
GSOL0=1367.0
ECC=1.6715e-02
OBL=23.44
CO2=360
TGR=288
DIFF=3.0e+04
EQ=0
AQUA=0
SIC=0.

for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            obl)    OBL=${VALUE} ;;
            ecc)    ECC=${VALUE} ;;
            co2)    CO2=${VALUE} ;;
            s0)     GSOL0=${VALUE} ;;
            gsol0)  GSOL0=${VALUE} ;;
            tgr)    TGR=${VALUE} ;;
            diff)   DIFF=${VALUE} ;;
            eq)   EQ=${VALUE} ;;
            aqua) AQUA=${VALUE} ;;
            sic) SIC=${VALUE} ;;
            *)
    esac
done

cp $SCRIPTDIR/template/most.cfg $SRCDIR

replmost "<obliq>" $OBL
replmost "<gsol0>" $GSOL0
replmost "<co2>" $CO2

./most.x -c most.cfg

mkdir -p $EXPDIR/$EXP
cp -R $SRCDIR/plasim/run/* $EXPDIR/$EXP/
cd $EXPDIR/$EXP/

# Fix runscript 
repl YEAR2=10 YEAR2=$YEARS most_plasim_run

# Fix single diffusivity
repl "NSHDIFF     =     1" "NSHDIFF     =     0" oceanmod_namelist
repl "HDIFFK      = 1.0e+05" "HDIFFK      = $DIFF" oceanmod_namelist
insert "TGR = $TGR" plasim_namelist

if [ "$AQUA" != "0" ]; then
     $SRCDIR/scripts/aqua.sh $TGR $SIC $EQ
else
     $SRCDIR/scripts/earth.sh $TGR $SIC
fi

makejob $EXP
}

setup () {

COMP=""
for ARGUMENT in "$@"
do
    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)

    case "$KEY" in
            comp)    COMP=${VALUE} ;;
            *)
    esac
done

# Prepare code
mkdir -p $BASEDIR
cd $BASEDIR
git clone https://github.com/jhardenberg/PLASIM.git $SRCDIR
cd $SRCDIR
./configure.sh
if [ -n "$COMP" ]; then
   cp $SCRIPTDIR/template/most_compiler.$COMP most_compiler  
fi
head "DIR=$SRCDIR/scripts" $SRCDIR/scripts/aqua.sh
head "DIR=$SRCDIR/scripts" $SRCDIR/scripts/earth.sh
}