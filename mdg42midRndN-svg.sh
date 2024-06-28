#!/bin/bash
#===================================================================================
#
#	 FILE:	mdg42midRndN-svg.sh
#
#	USAGE:	mdg42midRndN-svg.sh <num>
#
#		where <num> is the number of random MDG minuets to be generated, e.g., 50.
#		*** NOTE:  This script has to be in the same directory as mdg42mid+svg.sh. ***
#
# DESCRIPTION:	Used for generating <num> ABC files, each a Musical Dice Game (MDG)
#		minuet based on the rules given in Joseph Haydn's "Gioco Filarmonico" 
#
#      AUTHOR:	J.L.A. Uro (justineuro@gmail.com)
#     VERSION:	1.0.2
#     LICENSE:	Creative Commons Attribution 4.0 International License (CC-BY)
#     CREATED:	2024/06/24 19:48:24
#    REVISION:	
#==================================================================================

#----------------------------------------------------------------------------------
# define the function genSM() that randomly chooses an integer from 2 to 12, inclusive
#----------------------------------------------------------------------------------
genSM() { # RANDOM randomly generates an integer from 0 to 32767
	rnd=32768
	until [ $rnd -lt 32758 ]
	do
		rnd=$[RANDOM]
		if [ $rnd -lt 32758 ]; then echo $[rnd%11+2]; fi
	done
}

#----------------------------------------------------------------------------------
# define the function genST() that randomly chooses an integer from 1 to 6, inclusive
#----------------------------------------------------------------------------------
genST() { # RANDOM randomly generates an integer from 0 to 32767
	rnd=32768
	until [ $rnd -lt 32766 ]
	do
		rnd=$[RANDOM]
		if [ $rnd -lt 32766 ]; then echo $[rnd%6+1]; fi
	done
}



#----------------------------------------------------------------------------------
# declare the variables "diceS" as an array
# diceS - array containing the 16 outcomes from input line
#----------------------------------------------------------------------------------
declare -a diceS

#----------------------------------------------------------------------------------
# generate the <num> random minuets
#----------------------------------------------------------------------------------
i=1
while [ $i -le $1 ]; do
#----------------------------------------------------------------------------------
# generate the random 16-sequence of outcomes of the 16 throws of two dice for 
# the minuet and for the trio
#----------------------------------------------------------------------------------
	for j in {0..15}; do
		diceS[$j]=`genSM`
		diceS[$(( 16 + $j ))]=`genST`
	done

#----------------------------------------------------------------------------------
# generate a waltz in ABC notation and corresponding MIDI and svg for the current 
# diceS using mdg42mid+svg.sh
#----------------------------------------------------------------------------------
	./mdg42mid+svg.sh ${diceS[*]}
	i=`expr $i + 1`
done
#
##
####
