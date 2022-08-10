#!/bin/bash

. scripts/config.sh

CDO="cdo -s"

repl () {
        sed -i "s%$1%$2%g" $3
}
del () {
        sed -i "/$1/d" $2
}

makejob () {
        EXP=$1
        VAR=$2
        Y1=$3
        Y2=$4

        mkdir -p $JOBDIR
        mkdir -p $LOGDIR

        JOB=$JOBDIR/${EXP}_post.job

        cp $SCRIPTDIR/template/template_post.job $JOB
        repl "<exp>" $EXP $JOB
        repl "<y1>" $Y1 $JOB
        repl "<y2>" $Y2 $JOB
	repl "<scriptdir>" $SCRIPTDIR $JOB
        repl "<var>" $VAR $JOB
        repl "<expdir>" $EXPDIR $JOB
        repl "<logdir>" $LOGDIR $JOB
        if [ "$EMAIL" != "" ]; then
           repl "<email>" $EMAIL $JOB
        else
           del "<email>" $JOB
        fi
        if [ "$MEMORY" != "" ]; then
           repl "<mem>" $MEMORY $JOB
        else
           del "<mem>" $JOB
        fi

        if [ "$LAUNCH" == "1" ]; then
            sbatch $JOB
        fi
}

post () {
        mkdir -p $BASEDIR/post
        cd $BASEDIR/post

        EXP=$1
        VAR=$2
        Y1=$3
        Y2=$4
        makejob $EXP $VAR $Y1 $Y2
}
        
postexec () {
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


