#!/bin/bash

roslaunch squirrel_scenarios sim_prediction_toys.launch &

sleep 10;

for objects in $(seq 85 5 100)
do

for initial in $(seq 5 5 80)
do

## clear knowledge base and generate new initial state
echo "$1/generator.bash $objects $initial"
$1/generator.bash $objects $initial;

## run prediction on initial state
rosservice call /kcl_rosplan/initial_state_prediction_server "{}"

## save input and output files for later
mv /YOUR_PATH_HERE/example.csv ./$1/example_${objects}_${initial}.csv
mv /YOUR_PATH_HERE/predicted_missing_known_full.csv ./$1/predicated_${objects}_${initial}.csv

done
done

killall roslaunch;
