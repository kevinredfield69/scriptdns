#!/bin/bash

if [ $1 = "-a" ]
then
	if [ $2 = "-dir" ]
	then
		echo "$3		IN	A	$4"
	elif [ $2 = "-alias" ]
	then
		echo "$3		IN	CNAME	$4"
	fi
fi
