# Getting and Cleaning Data - Course Project

## Author

Mikhail Kalesnikau

## Short Description

This script will download the raw data set and generate the tidy data set at `./tidy_set.txt`

## Data Source

Human Activity Recognition Using Smartphones Dataset

* Original data: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Original description of the dataset: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## How To Run The Script

* Clone this repository
* Copy the contenst of the remote repository to your local repository
* Run the run\_analysis.R script from the local repository folder

## Detailed Script Activity

The run\_analysis.R script will take the following actions:

* install required packages (data.table and reshape2)
* download raw data archive (if it's not yet exist locally)
* extract raw data from the archive
* read activity labels
* read features
* create the mask on the mean and standard deviation features
* read test set
* extract only the measurements on the mean and standard deviation for each measurement (from test set)
* add activity labels (to test set)
* bind test set
* read train set
* extract only the measurements on the mean and standard deviation for each measurement (from train set)
* add activity labels (to train set)
* bind train set
* merge the training and the test sets to create one data set
* create a second, independent tidy data set with the average of each variable for each activity and each subject
* write the tidy data set into ./tidy_set.txt
