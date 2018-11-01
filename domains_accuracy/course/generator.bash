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
no_program=$(($no_objects))
no_course=$((3*$no_program))
no_student=$((2*$no_program))
no_med_student=$((2*$no_program))
no_top_student=$((1*$no_program))

rosservice call /kcl_rosplan/clear_knowledge_base "{}" 

# create objects
add_instances $no_student "student"
add_instances $no_top_student "top_student"
add_instances $no_med_student "med_student"
add_instances $no_course "course"
add_instances $no_program "program"

# create facts
add_all_facts "can-take" $no_top_student "s" "top_student" $no_course "c" "course" $initial_knowledge
add_all_facts "can-take" $no_med_student "s" "med_student" $no_course "c" "course" 50


for i in $(seq 0 $no_program)
do
facts="update_type: 0
knowledge:"
for j in $(seq 0 2)
do
program=$((1 + $i))
course1=$(($i*5 + $j))
course2=$((1 + $i*5 + $j))
if [ $j -ne 4 ]
then
facts="$facts
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'prerequisite'
  values:
  - {key: 'c1', value: 'course$course1'}
  - {key: 'c2', value: 'course$course2'}
  function_value: 0.0
  is_negative: false"
fi
facts="$facts
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'in_program'
  values:
  - {key: 'c', value: 'course$course1'}
  - {key: 'p', value: 'program$program'}
  function_value: 0.0
  is_negative: false"
done;
rosservice call /kcl_rosplan/update_knowledge_base_array "$facts";
done;
