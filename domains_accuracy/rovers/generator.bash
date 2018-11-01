#!/bin/bash

#functions
add_instances()
{
objs="update_type: 0
knowledge:"
for i in $(seq 0 $1)
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
# 1:name
# 2:min 3:max 4:label 5:prefix
# 6:min 7:max 8:label 9:prefix
# 10: initial_knowledge
add_all_facts()
{
count=0
facts="update_type: 0
knowledge:"
for i in $(seq $2 $3)
do
for j in $(seq $6 $7)
do
rand=$(($RANDOM%100))
if [ $rand -le ${10} ]
then
count=$(($count+1))
facts="$facts
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: '$1'
  values:
  - {key: '$4', value: '$5$i'}
  - {key: '$6', value: '$9$j'}
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
no_rover=$(($no_objects / 5))
no_waypoint=$(($no_objects / 5))
no_bad_waypoint=$(($no_objects / 5))
no_sample=$(($no_objects / 5))
no_bad_sample=$(($no_objects / 5))

rosservice call /kcl_rosplan/clear_knowledge_base "{}" 

# create objects
add_instances $no_waypoint "waypoint"
add_instances $no_bad_waypoint "waypoint"
add_instances $no_rover "rover"
add_instances $no_sample "sample"
add_instances $no_bad_sample "bad_sample"

# create facts
add_all_facts "adjacent" 0 $no_waypoint "wp1" "waypoint" 0 $no_waypoint "wp2" "waypoint" 101
add_all_facts "adjacent" 0 $no_bad_waypoint "wp1" "bad_waypoint" 0 $no_bad_waypoint "wp2" "bad_waypoint" 101

add_all_facts "same-type" 0 $no_sample "s1" "sample" 0 $no_sample "s2" "sample" 101
add_all_facts "same-size" 0 $no_sample "s1" "sample" 0 $no_sample "s2" "sample" 101
add_all_facts "same-type" 0 $no_bad_sample "s1" "bad_sample" 0 $no_bad_sample "s2" "bad_sample" 101
add_all_facts "same-size" 0 $no_bad_sample "s1" "bad_sample" 0 $no_bad_sample "s2" "bad_sample" 101

add_all_facts "can_sample_at" 0 $no_rover "r" "rover" 0 $no_waypoint "wp" "waypoint" $initial_knowledge
add_all_facts "can_sample" 0 $no_rover "r" "rover" 0 $no_sample "s" "sample" $initial_knowledge
add_all_facts "can_move" 0 $no_rover "r" "rover" 0 $no_waypoint "to" "waypoint" $initial_knowledge
