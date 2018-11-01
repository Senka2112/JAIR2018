# JAIR2017


This repository contains test scripts for the results presented in the paper ["Using Machine Learning for Decreasing State Uncertainty in Planning"] by Senka Krivic, Michael Cashmore, Daniele Magazzeni, Sandor Szedmak and Justus Piater

Prerequisities
============

You need the ROSPlan repository
(follow the installation instructions [here](https://github.com/KCL-Planning/ROSPlan/wiki/a.-Installation) )
```
git clone https://github.com/clearpathrobotics/occupancy_grid_utils
git clone -b squirrel https://github.com/kcl-planning/ROSPlan.git
```
Additionally you will require Flex and MongoDB.
```
sudo apt-get install flex
sudo apt-get install mongodb
sudo apt-get install ros-indigo-mongodb-store
```

You also need the [squirrel-prediction repository](https://github.com/squirrel-project/squirrel_prediction) which represents the core method for predicting missing values in the planning state.
```
git clone https://github.com/squirrel-project/squirrel_prediction
```
Additionally  you need to install a repository containing squirrel messages: [squirrel_common](https://github.com/squirrel_project/squirrel_common)

Planning domains
============
- 'tidy-room', inspired by the problem of cleaning a child’s room of project [SQUIRREL](http://www.squirrel-project.eu/)
- 'courseadvisor', adapted from [Guerin et al.](https://orff.uc3m.es/bitstream/handle/10016/14914/proceedings-WS-IPC2012.pdf?sequence=1)
- 'mars-rovers', a multi-robot version of the navigation problem of [Cassandra et al.](http://people.csail.mit.edu/lpk/papers/iros96.ps) 
- 'persistent-auv', described by [Palomeras et al.](https://www.springerprofessional.de/en/toward-persistent-autonomous-intervention-in-a-subsea-panel/10930422)
 
 These domains are contained in this repository under [domains_accuracy](https://github.com/Senka2112/JAIR2018/tree/master/domains_accuracy)

Problems defined for evaluation with conditional planning are given under [domain_problem_complexity](https://github.com/Senka2112/JAIR2018/tree/master/domain_problem_complexity)

Runing the tests scripts
========================

**Running only predictions**

You can run the service for predictions as:
```
rosrun squirrel_relations_prediction predict_relations_server.py 
```

Service call for relations prediction:

```
# input parameters
string data_path
string input_file
string output_file
int32 number_of_columns
---
#output
bool finished
```
Input file should contain the representation of a graph with missing values.
First two columns have to contain string IDs of origin adn destination vertices. Rest columns represent the edges. The file has to be in .csv format where columns are separated with commas and rows with a new line.  Empty values mark unknown edges in a graph. '0' marks no edge between vertices and '1' marks existance of the dge between two vertices.
An example fo such file is given in [examples](https://github.com/Senka2112/IJCAI2017/tree/master/examples/known.csv)


**Running planning and predictions**

GENERATOR:

In each domain folder there is the file: generator.bash

The generator script creates a problem instance in the ROSPlan Knowledge Base. The generator script takes two arguments.
./generator.bash [number of objects] [percent initial knowledge]

The generator scripts requires that:
- ROSPlan KB is running
- The /rosplan/domain\_path parameter is set to the correct domain
The generator script automatically clears the KB before generation.

PREDICTION:

The run\_experiment and make\_full bash files are used to generate csv files. The take on argument.
./make\_full [domain name]

The scripts:
- wait for 20 seconds while previous ROSPlan processes are killed
- start ROSPlan with the correct domain. This is an absolute path to the folder so will need to be changed.
- wait for 20 secods while ROSPlan starts
- Loop for 5-80 percent knowledge and 5-100 objects
- - call the generator script
- - call the prediction service
- - save the files as above
- Kill the ros launch

Additional info
===============

The version of the MMMVR framework which does not recquire ROS can be found at [mmr_mmmvr](https://iis.uibk.ac.at/software/mmr_mmmvr).


