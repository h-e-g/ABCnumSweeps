#!/bin/bash

### Guillaume Laval (12 08 2021)
### Script used to compute the OR
### This script is provided *as is* without warranty of any kind.

shopt -s expand_aliases
source ~/.bashrc
#R="/cygdrive/c/Program\ Files/R/R-3.2.3/bin/x64/R.exe"


if [ -z $1 ]
then
	echo "missing arguments, abort"; exit
		
else
	LOGISTIC_REGRESSION_FILE="$1"
	LOGISTIC_MODEL="$2"
fi

	R CMD BATCH "--args $LOGISTIC_REGRESSION_FILE $LOGISTIC_MODEL" OR_logistic_reg.r
