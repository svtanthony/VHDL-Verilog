#!/bin/bash
# declare an array called array and define 3 vales
array=( 100 200 400 800 1600 3200 6400 12800 25600 30000 )
for i in "${array[@]}"
do
	#modify file
	sed -i "16s/.*/   long long size = $i;/" program0.c
	sed -i "16s/.*/   long long size = $i;/" program1.c
	make > /dev/null 2>&1
	STARTTIME=$(date +%s%3N)
	./prog0.out
	ENDTIME=$(date +%s%3N)
	ELAPSED0=$(($ENDTIME - $STARTTIME))
	STARTTIME=$(date +%s%3N)
	./prog1.out
	ENDTIME=$(date +%s%3N)
	ELAPSED1=$(($ENDTIME - $STARTTIME))
	echo "$i $ELAPSED0 $ELAPSED1" >> data.txt
done
