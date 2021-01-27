# Silkworm

A physics pipelines for simulating fields in Ansys EDT and particle tracks in Kassiopeia for analsys in Matlab.

## Install

This is intended to be executed on a CentOS 6 system. No other platforms are supported although most linux systems should work.

If you are an NC State Physics user this is already installed on the whisper station and can be accessed by doing `source ~arallen/.bashrc`

### Requirements

This framework requires the following packages:
- Ansys Electromagnetics Desktop
- Matlab r2020
- Kassiopeia (https://github.com/KATRIN-Experiment/Kassiopeia)
- Python (2.7) [requires toml and tqdm modules]
- ROOT (https://ph-root-2.cern.ch/)

### Instructions

1. Clone the repository from github
2. Find and modify core/activate file to point to correct paths
3. Run `source core/active` (this sets up the environment)
4. Ensure the correct python version and packages are on your path
4. Run `pipeline [path_to_config]` to start the pipeline for an experiment


## Overview

This section gives a brief overview of the structure of the system. The goal is to provide a simple versioned system for tracking many experiments and variations.

### File Structure

The top level directory contains three folders... core, sims, and report.

The core folder contains the code that is common to all of the experiments.

The sims folder contains a directory structure. There can be many nested folders, these contain *experiments*.

The reports folder contains tex files for writing any reports associated with the experiments.

#### Experiments

An experiment is a folder under the sims folder tree that contains a `config.toml` file.

This file defines what needs to be executed for a given experiment. Here is an example

```
[fields]
project="waveguide.aedt"
script="extract_fields.py"

[tracks]
sim="Simulation.xml"
output="Output.root"
```

There are two currently supported directives. The fields directive and the tracks directive.

The fields directive tells the system to execute an Ansys batch solve on the defined project file and then to execute the given automation script to extract the data from it.

The tracks directive tells the system to execute a Kassiopeia simulation defined by the given xml project and then to process the given root file into CSV format to be read by Matlab


In addition to the `config.toml` file there is a matlab folder in which all the matlab scripts associated with the experiment should be placed. These will all be executed upon completion of the experiment. This will create an `img` folder in the root of the experiment which will contain the plots of the outputs. 

### Requirements

In order for the system to function, an experiment must satisfy the following requirements. 

- The matlab script must use `load_sim()` to load in the data from Kassiopeia
- The matlab script must use `saveas(gcf, '../img/[fname].png')` to save the images
- The Kassiopeia simulation file must write the root file in the `./` directory
- The Kassiopeia simulation file must read in vtk field files from `../fields/fields.vtk`
- The Ansys python script must export all data to the `./` directory
- All relative file locations given in the `config.toml` are done from the root dir of the experiment


### Branching

There are currently two branches, a master branch and a report branch. The goal is to ensure that all experiments have updated images and data in the report branch for the report to compile into it. The commits to the report branch are what would be considered "complete" and ready to view. 

## Support

If you need support please contact Alexander Allen <arallen4@ncsu.edu> 

