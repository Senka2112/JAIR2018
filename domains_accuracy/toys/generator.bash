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
# 1:name 2:number 3:label 4:prefix 5:number 6:label 7:prefix 8: initial_knowledge
add_all_facts()
{
count=0
facts="update_type: 0
knowledge:"
for i in $(seq 0 $2)
do
for j in $(seq 0 $5)
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
no_waypoint=10
no_robot=$(($no_objects / 20))
no_box=$(($no_objects / 20))
no_block=$(($no_objects / 3))
no_car=$(($no_objects / 3))
no_cup=$(($no_objects / 3))

rosservice call /kcl_rosplan/clear_knowledge_base "{}" 

# create objects
add_instances $no_waypoint "waypoint"
add_instances $no_robot "robot"
add_instances $no_box "box"
add_instances $no_car "car"
add_instances $no_block "block"
add_instances $no_cup "cup"

# create facts
add_all_facts "can_fit_inside" $no_block "t" "block" $no_box "b" "box" $initial_knowledge
add_all_facts "can_fit_inside" $no_car "t" "car" $no_box "b" "box" $initial_knowledge
add_all_facts "can_fit_inside" $no_cup "t" "cup" $no_box "b" "box" $initial_knowledge

add_all_facts "can_stack_on" $no_block "t1" "block" $no_block "t2" "block" $initial_knowledge
add_all_facts "can_stack_on" $no_block "t1" "block" $no_cup "t2" "cup" $initial_knowledge
add_all_facts "can_stack_on" $no_block "t1" "block" $no_car "t2" "car" $initial_knowledge

add_all_facts "can_stack_on" $no_car "t1" "car" $no_block "t2" "block" $initial_knowledge
add_all_facts "can_stack_on" $no_car "t1" "car" $no_cup "t2" "cup" $initial_knowledge
add_all_facts "can_stack_on" $no_car "t1" "car" $no_car "t2" "car" $initial_knowledge

add_all_facts "can_stack_on" $no_cup "t1" "cup" $no_block "t2" "block" $initial_knowledge
add_all_facts "can_stack_on" $no_cup "t1" "cup" $no_cup "t2" "cup" $initial_knowledge
add_all_facts "can_stack_on" $no_cup "t1" "cup" $no_car "t2" "car" $initial_knowledge

add_all_facts "can_pickup" $no_robot "r" "robot" $no_block "t" "block" $initial_knowledge
add_all_facts "can_pickup" $no_robot "r" "robot" $no_car "t" "car" $initial_knowledge
add_all_facts "can_pickup" $no_robot "r" "robot" $no_cup "t" "cup" $initial_knowledge

add_all_facts "can_push" $no_robot "r" "robot" $no_block "t" "block" $initial_knowledge
add_all_facts "can_push" $no_robot "r" "robot" $no_car "t" "car" $initial_knowledge
add_all_facts "can_push" $no_robot "r" "robot" $no_cup "t" "cup" $initial_knowledge
