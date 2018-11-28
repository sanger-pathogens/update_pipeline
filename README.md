# update_pipeline
Update and validate a pipelines metadata

[![Build Status](https://travis-ci.org/sanger-pathogens/update_pipeline.svg?branch=master)](https://travis-ci.org/sanger-pathogens/update_pipeline)   
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-brightgreen.svg)](https://github.com/sanger-pathogens/update_pipeline/blob/master/GPL-LICENSE)   

## Contents
  * [Introduction](#introduction)
  * [Installation](#installation)
    * [Required dependencies](#required-dependencies)
    * [Debian/Ubuntu](#debianubuntu)
    * [Running the tests](#running-the-tests)
  * [Usage](#usage)
    * [update\_pipeline\.pl](#update_pipelinepl)
    * [update\_pb\_pipeline](#update_pb_pipeline)
    * [update\_pipeline\_from\_spreadsheet\.pl](#update_pipeline_from_spreadsheetpl)
    * [validate\_pipeline\.pl](#validate_pipelinepl)
  * [License](#license)
  * [Feedback/Issues](#feedbackissues)

## Introduction
The scripts in this repository can be used to update and validate the metadata for a pipeline.

## Installation

update_pipeline has the following dependencies:

### Required dependencies
* [fastqcheck](https://github.com/sanger-pathogens/fastqcheck)
* [VR-Codebase](https://github.com/sanger-pathogens/vr-codebase.git)
* [MySQL](https://www.mysql.com/downloads/)

There are a few ways to install update-pipeline. If you encounter an issue when installing update_pipeline please contact your local system administrator. If you encounter a bug please log it [here](https://github.com/sanger-pathogens/update_pipeline/issues) or email us at path-help@sanger.ac.uk

### Debian/Ubuntu
These instructions assume you have root access and a working MySQL set up. To install update_pipeline and its dependencies, run:

```
apt-get update -qq
apt-get install -y libmysqlclient-dev autoconf libtool
git clone https://github.com/sanger-pathogens/update_pipeline.git && cd update_pipeline
./install_dependencies.sh
dzil authordeps --missing | cpanm
dzil listdeps --missing | cpanm
```
### Running the tests
The test can be run with dzil from the top level directory:  
  
`dzil test`  

## Usage
update_pipeline consists of four scripts for updating the metadata of a pipeline.

### update_pipeline.pl
```
Usage: ./update_pipeline.pl
  -s|--studies                 <file of study names>
  -n|--study_name              <a single study name to update>
  -d|--database                <vrtrack database name>
  -f|--max_files_to_return     <optional limit on num of file to check per process>
  -p|--parallel_processes      <optional number of processes to run in parallel, defaults to 1>
  -v|--verbose                 <print out debugging information>
  -r|--min_run_id              <optionally filter out errors below this run_id, defaults to 10000>
  -u|--update_if_changed       <optionally delete lane & file entries, if metadata changes, for reimport>
  -w|--dont_use_warehouse      <dont use the warehouse to fill in missing data>
  -tax|--taxon_id              <optionally provide taxon id to overwrite species info in bam file common name>
  -spe|--species                     <optionally provide the species name, which in combination with -tax avoids an NCBI lookup>
  -sup|--use_supplier_name     <optionally use the supplier name from the warehouse to populate name and hierarchy name of the individual table>
  -run|--specific_run_id       <optionally provide a specfic run id for a study>
  -min|--specific_min_run      <optionally provide a specfic minimum run id for a study to import>
  -nop|--no_pending_lanes      <optionally filter out lanes whose npg QC status is pending>
  -md5|--override_md5          <optionally update md5 on imported file if the iRODS md5 changes>
  -wdr|--withdraw_del          <optionally withdraw a lane if has been deleted from iRODS>
  -trd|--include_total_reads   <optionally write the total_reads from bam metadata to the file table in vrtrack>
  -l|--lock_file               <optional lock file to prevent multiple instances running>
  -t|--file_type               <optionally change the default file type to import from bam (to cram)>
  -h|--help                    <this message>

Update the tracking database from IRODs and the warehouse.

# update all studies listed in the file in the given database
./update_pipeline.pl -s my_study_file -d pathogen_abc_track

# update only the given study
./update_pipeline.pl -n "My Study" -d pathogen_abc_track

# Lookup all studies listed in the file, but only update the 500 latest files in IRODs
./update_pipeline.pl -s my_study_file -d pathogen_abc_track -f 500

# perform the update using 10 processes
./update_pipeline.pl -s my_study_file -d pathogen_abc_track -p 10

# import cram files
./update_pipeline.pl -s my_study_file -d pathogen_abc_track --file_type cram
```
### update_pb_pipeline
```
Usage: update_pb_pipeline [options]
Update the metadata of PB samples from the warehouse and iRODS and insert it into a VRTracking database.

  -s|--studies                 <file of study names>
  -n|--study_name              <a single study name to update>
  -d|--database                <vrtrack database name>
  -f|--max_files_to_return     <optional limit on num of file to check per process>
  -p|--parallel_processes      <optional number of processes to run in parallel, defaults to 1>
  -v|--verbose                 <print out debugging information>
  -r|--min_run_id              <optionally filter out errors below this run_id, defaults to 6000>
  -u|--update_if_changed       <optionally delete lane & file entries, if metadata changes, for reimport>
  -w|--dont_use_warehouse      <dont use the warehouse to fill in missing data>
  -tax|--taxon_id              <optionally provide taxon id to overwrite species info in bam file common name>
  -spe|--species               <optionally provide the species name, which in combination with -tax avoids an NCBI lookup>
  -sup|--use_supplier_name     <optionally use the supplier name from the warehouse to populate name and hierarchy name of the individual table>
  -run|--specific_run_id       <optionally provide a specfic run id for a study>
  -min|--specific_min_run      <optionally provide a specfic minimum run id for a study to import>
  -nop|--no_pending_lanes      <optionally filter out lanes whose npg QC status is pending>
  -md5|--override_md5          <optionally update md5 on imported file if the iRODS md5 changes>
  -wdr|--withdraw_del          <optionally withdraw a lane if has been deleted from iRODS>
  -trd|--include_total_reads   <optionally write the total_reads from bam metadata to the file table in vrtrack>
  -l|--lock_file               <optional lock file to prevent multiple instances running>
  -h|--help                    <this message>

# update all studies listed in the file in the given database
update_pb_pipeline -s my_study_file -d pathogen_abc_track

# update only the given study
update_pb_pipeline -n "My Study" -d pathogen_abc_track

# This help message
update_pb_pipeline -h
```
### update_pipeline_from_spreadsheet.pl
```
Usage: ./update_pipeline_from_spreadsheet.pl [options] spreadsheet.xls
  -d|--database                <vrtrack database name>
  -v|--verbose                 <print out debugging information>
  -f|--files_to_add_directory  <base directory containing files to add to the pipeline>
  -p|--pipeline_base_directory <required if -f provided, path to sequencing pipeline root directory>
  -u|--update_if_changed       <optionally delete lane & file entries, if metadata changes, for reimport>
  -t|--threads                 <number of threads to use>
  -r|--data_access_group       <restrict access to this unix group>

  -h|--help                    <this message>

# update the database only
./update_pipeline_from_spreadsheet.pl -d pathogen_abc_track spreadsheet.xls

# update the database and copy the sequencing files
./update_pipeline_from_spreadsheet.pl -d pathogen_abc_track -f /path/to/incoming/sequencing_files -p /lustre/scratch10x/xxx/seq-pipelines spreadsheet.xls
```
### validate_pipeline.pl
```
Usage: ./validate_pipeline.pl
            --studies               <study name or file of SequenceScape study names>
            [--database             <vrtrack database name>]
            --checkreadcount        <activate read count consistency evaluation (IO intensive)>
            -nop|--no_pending_lanes <optionally filter out lanes whose npg QC status is pending>
            --file_type             <cram or bam, defaults to bam>
            --specific_min_run      <dont check lanes below this run id (default 10000)>
            --help                  <this message>

Check to see if the pipeline is valid compared to the data stored in IRODS
```

## License
update_pipeline is free software, licensed under [GPLv3](https://github.com/sanger-pathogens/update_pipeline/blob/master/GPL-LICENSE).

## Feedback/Issues
Please report any issues to the [issues page](https://github.com/sanger-pathogens/update_pipeline/issues) or email path-help@sanger.ac.uk
