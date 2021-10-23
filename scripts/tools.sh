#!/bin/bash
# set -ex

. scripts/config.sh

replmost () {
	sed -i "s%$1%$2%g" $SRCDIR/most.cfg
}
repl () {
	sed -i "s%$1%$2%g" $3
}
del () {
	sed -i "/$1/d" $2
}
insert () {
	sed -i "/^ \/END.*/i $1" $2
}
insert2 () {
        sed -i "1a$1" $2
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
        repl "<res>" $RES $JOBDIR/$EXP.job
        repl "<nlev>" $NLEV $JOBDIR/$EXP.job
        repl "<expdir>" $EXPDIR $JOBDIR/$EXP.job
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
        repl "<lsg>" $LSG $JOBDIR/$EXP.job
        repl "<ncores>" $NCPU $JOBDIR/$EXP.job
        if [ "$EMAIL" != "" ]; then
           repl "<email>" $EMAIL $JOBDIR/$EXP.job
        else
           del "<email>" $JOBDIR/$EXP.job
        fi
        if [ "$MEMORY" != "" ]; then
           repl "<mem>" $MEMORY $JOBDIR/$EXP.job
        else
           del "<mem>" $JOBDIR/$EXP.job
        fi
  
        if [ "$LAUNCH" == "1" ]; then 
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
LSG=0
RES=t21
NLEV=10
NCPU=1
PARAM=""
VERBOSE=0

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
            lsg) LSG=${VALUE} ;;
            nlev) NLEV=${VALUE} ;;
            res) RES=${VALUE} ;;
            years) YEARS=${VALUE} ;;
            ncores) NCPU=${VALUE} ;;
            ncpu) NCPU=${VALUE} ;;
            param) PARAM=${VALUE} ;;
            verbose) VERBOSE=${VALUE} ;;
            *)
    esac
done

cp $SCRIPTDIR/template/most.cfg $SRCDIR

replmost "<obliq>" $OBL
replmost "<eccen>" $ECC
replmost "<gsol0>" $GSOL0
replmost "<co2>" $CO2
if [ "$LSG" != "0" ]; then
    replmost "<lsg>" 1
else
    replmost "<lsg>" 0
fi
T21=0
T31=0
T42=0
case $RES in
  t21) T21=1;;
  t31) T31=1;;
  t42) T42=1;;
esac
replmost "<t21>" $T21
replmost "<t31>" $T31
replmost "<t42>" $T42
replmost "<nlev>" $NLEV
replmost "<ncores>" $NCPU

./most.x -c most.cfg

mkdir -p $EXPDIR/$EXP
cp -R $SRCDIR/plasim/run/* $EXPDIR/$EXP/
cd $EXPDIR/$EXP/

# Fix runscript 
if [ "$YEARS" != "" ]; then
   repl YEAR2=10 YEAR2=$YEARS most_plasim_run
fi

insert "TGR = $TGR" plasim_namelist
if [ "$EXO" != "" ] && [ "$EXO" != "0" ]; then
# Fix single diffusivity
  repl "NSHDIFF     =     1" "NSHDIFF     =     0" oceanmod_namelist
  repl "HDIFFK      = 1.0e+05" "HDIFFK      = $DIFF" oceanmod_namelist

  if [ "$AQUA" != "0" ]; then
     $SRCDIR/scripts/aqua.sh $TGR $SIC $EQ
     if [ "$LSG" != "0" ]; then
         $SRCDIR/scripts/maketopo $LSG > topogr  # Aquaplanet with fixed depth $LSG
         insert2 "naqua=1" input  # No friction corrections
         echo 84 1 > kleiswi  # Initalizes ocean with constant values (5°C, 34.5 psu)
     fi
  else
     $SRCDIR/scripts/earth.sh $TGR $SIC
  fi
fi

if [ "$PARAM" != "" ]; then
   cp $PARAM $EXPDIR/
# Special interpretation of TFRC1 and TFRC2
   TFRC1=1728000
   TFRC2=8640000
   while read line; do
# reading each line
     a=( $line )
     par="${a[0]}"
     nl="${a[1]}"
     val="${a[2]}"
     [ $VERBOSE = 1 ] && echo "Experiment $EXP Substituted parameter $par in namelist $nl with value $val"
     if [ $par != TFRC1 ] && [ $par != TFRC2 ]; then
        insert " $par = $val" ${nl}_namelist
     fi
     [ $par = TFRC1 ] && TFRC1=$val
     [ $par = TFRC2 ] && TFRC2=$val
   done < $PARAM
   insert " TFRC = $TFRC1, $TFRC2" plasim_namelist
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
   cp $SCRIPTDIR/template/most_compiler_mpi.$COMP most_compiler_mpi
fi
head "DIR=$SRCDIR/scripts" $SRCDIR/scripts/aqua.sh
head "DIR=$SRCDIR/scripts" $SRCDIR/scripts/earth.sh
}
