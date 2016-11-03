#Peer-graded Assignment: Getting and Cleaning Data Course Project
The script "run_analysis.R" in this repository can be used to transform the data from the url https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip into a tidy dataset.

##Steps
-Ensure the files exist in the working directory, if not the file is downloaded and unziped.
-Merges the training and the test sets to create one data set.
-Extracts only the measurements on the mean and standard deviation for each measurement.
-Uses descriptive activity names to name the activities in the data set
-Appropriately labels the data set with descriptive variable names.
-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Usage
Set the working directory to the folder where is the run_analysis.R script.
Run the command source("run_analysis.R") to generate a file called "tidydata.txt".