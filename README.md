# Readme for run_anaysis.R

## Description of project

This script realize course project  from the "Getting and Cleaning Data" course on Coursera. Purpose of script run_analysis.R is to create tidy dataset with measurements on the mean and standard deviation for each measurement.
 from UCI HAR Dataset. Full dataset is avaliable on link [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). Another goal of script is create small dataset with means of values.

## Requirements

1. The R script, run_analysis.R must be located in write-accesible directory - script loads and extract UCI HAR Dataset by himself

2. Script uses library dplyr and reshape. If they not installed, script installs them.

## Script result

Script creates 2 dataset in global environment: tidydataset and tidydatasetmean. First is Tidy dataset created from original data. Codebook for this data located in file "CodeBook.md". Second dataset creates from first with the average of each variable for each activity and each subject. Also Datasets saved in txt files: tidyfull.txt (first dataset) and tidyavg.txt (second dataset)

## Script Run

Just run `source("run_analysis.R")`