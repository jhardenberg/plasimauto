#!/bin/bash

. scripts/config.sh

CDO="cdo -s"
post () {
        mkdir -p $BASEDIR/post
        cd $BASEDIR/post

 	EXP=$1
        VAR=$2
        RANGE=$3
        IDIR=$EXPDIR/$EXP/output
        ODIR=$POSTDIR/$EXP/$VAR
        mkdir -p $ODIR
        cd $ODIR
        rm -f ${EXP}_${VAR}_zon.nc ${EXP}_${VAR}_fld.nc
# rst=rsut+tisr    tisr=rst-rsut    
        if [ "$VAR" = "al" ]; then
            CALC=-expr,"al=-rsut/(rst-rsut)"
        elif [ "$VAR" = "pr" ]; then
            CALC=-expr,"pr=prc+prl"
        else
            CALC=""
        fi 
        for f in $IDIR/MOST_PLA.*.nc
        do
          $CDO cat -timmean -zonmean -selname,$VAR $CALC $f temp_zon$$.nc
          $CDO cat -timmean -fldmean -selname,$VAR $CALC $f ${EXP}_${VAR}_fld.nc
        done
        $CDO timmean -selyear,$RANGE temp_zon$$.nc ${EXP}_${VAR}_zon.nc
        $CDO outputtab,date,lat,value ${EXP}_${VAR}_zon.nc >  ${EXP}_${VAR}_zon.txt
        $CDO outputtab,date,value ${EXP}_${VAR}_fld.nc >  ${EXP}_${VAR}_fld.txt
        rm temp_zon$$.nc
}


