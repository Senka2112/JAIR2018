#!/bin/bash

#functions
add_instances()
{
objs="update_type: 0
knowledge:"
for i in $(seq 0 $(($1-1)) )
do
objs="$objs
- knowledge_type: 0
  instance_type: '$2'
  instance_name: '$2$i'
  attribute_name: ''
  values:
  - {key: '', value: ''}
  function_value: 0.0
  is_negative: false"
done;
rosservice call /kcl_rosplan/update_knowledge_base_array "$objs";
}

# 1:name 2:number 3:label 4:prefix 5:number 6:label 7:prefix 8: initial_knowledge 
add_all_facts()
{
count=0
facts="update_type: 0
knowledge:"
for i in $(seq 0 $(($2-1)) )
do
for j in $(seq 0 $(($5-1)) )
do
rand=$(($RANDOM%100))
if [ $rand -le $8 ]
then
count=$(($count+1))
facts="$facts
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: '$1'
  values:
  - {key: '$3', value: '$4$i'}
  - {key: '$6', value: '$7$j'}
  function_value: 0.0
  is_negative: false"
if [ $count -eq 57 ]
then
rosservice call /kcl_rosplan/update_knowledge_base_array "$facts";
facts="update_type: 0
knowledge:"
count=0
fi
fi
done;
done;
if [ $count -gt 0 ]
then
rosservice call /kcl_rosplan/update_knowledge_base_array "$facts";
fi
}

# 1:name 2:lower_bound 3:label 4:prefix 5:lower_bound 6:label 7:prefix 8: initial_knowledge 9: upper_bound 1 10: upper_bound
add_some_facts()
{
count=0
facts="update_type: 0
knowledge:"
for i in $(seq $2 $9)
do
for j in $(seq $5 ${10} )
do
rand=$(($RANDOM%100))
if [ $rand -le $8 ]
then
count=$(($count+1))
facts="$facts
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: '$1'
  values:
  - {key: '$3', value: '$4$i'}
  - {key: '$6', value: '$7$j'}
  function_value: 0.0
  is_negative: false"
if [ $count -eq 57 ]
then
rosservice call /kcl_rosplan/update_knowledge_base_array "$facts";
facts="update_type: 0
knowledge:"
count=0
fi
fi
done;
done;
if [ $count -gt 0 ]
then
rosservice call /kcl_rosplan/update_knowledge_base_array "$facts";
fi
}

# args
no_objects=$1
initial_knowledge=$2

# object counts
no_auv=3

no_ip=$(($no_objects))
no_pillar=$(($no_objects))
no_wp=$(($no_ip*3))

no_panels=$(($no_objects))
no_valves=$((2*$no_panels))
no_chains=$(($no_objects))


rosservice call /kcl_rosplan/clear_knowledge_base "{}" 

# create objects
add_instances $no_auv "auv"
add_instances $no_wp "waypoint"
add_instances $no_ip "ip"
add_instances $no_valves "valve"
add_instances $no_panels "panel"
add_instances $no_chains "chain"
add_instances $no_pillar "pillar"

# create facts
for step in $(seq 0 $(($no_ip-1)) )
do
add_some_facts "connected" $(($step*3)) "wp1" "waypoint" $(($step*3)) "wp2" "waypoint" $initial_knowledge $(($step*3+2)) $(($step*3+2))
add_some_facts "can-see_pillar" $(($step*3)) "wp" "waypoint" $(($step)) "p" "pillar" $initial_knowledge $(($step*3+2)) $step
add_some_facts "can-see" $(($step*3)) "wp" "waypoint" $(($step)) "ip" "ip" $initial_knowledge $(($step*3+2)) $step
done

for step in $(seq 0 $(($no_panels-1)) )
do
add_some_facts "can-examine" $(($step*3)) "wp" "waypoint" $(($step)) "p" "panel" $initial_knowledge $(($step*3+2)) $step
add_some_facts "can-reach" $(($step*3)) "wp" "waypoint" $(($step)) "p" "panel" $initial_knowledge $(($step*3+2)) $step
add_some_facts "on" $(($step*2)) "a" "valve" $step "p" "panel" $initial_knowledge $(($step*2+1)) $step
done

add_all_facts "can-turn" $no_auv "v" "vehicle" $no_valves "a" "valve" $initial_knowledge
add_all_facts "can-hover" $no_wp "wp1" "waypoint" $no_wp "wp2" "waypoint" $initial_knowledge
