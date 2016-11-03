#CODEBOOK for Peer-graded Assignment: Getting and Cleaning Data Course Project
This CodeBook describes the transformations applied over the UCI HAR Dataset, the variables and data generated in the outputed file.

##TRANSFORMATION
To create the tidy data the following procedures were applied.
1) Merge all the training data and the testing data in one dataset:

```
\#get the features
features <- read_delim("UCI HAR Dataset/features.txt", 
                       delim = " ",
                       col_names = c("id", "name"))

\#get the activities
activities <- read_table("UCI HAR Dataset/activity_labels.txt", 
                         col_names = c("id", "activity"))

\#get training subject data
trainSubjects <- read_table("UCI HAR Dataset/train/subject_train.txt",
                            col_names = c("subject"),
                            col_types = cols(.default = col_integer()))

\#get training activities data
trainActivities <- read_table("UCI HAR Dataset/train/y_train.txt",
                              col_names = c("id"),
                              col_types = cols(.default = col_integer()))

\#get training measurement data
trainData <- read_table("UCI HAR Dataset/train/X_train.txt", 
                        col_types = cols(.default = col_double()),
                        col_names = FALSE,
                        progress = FALSE)

names(trainData)<-features$name

\#bind subject, activity and data
trainData <- cbind(trainSubjects, trainActivities, trainData)

\#get test subject data
testSubjects <- read_table("UCI HAR Dataset/test/subject_test.txt",
                            col_names = c("subject"),
                            col_types = cols(.default = col_integer()))

\#get test activities data
testActivities <- read_table("UCI HAR Dataset/test/y_test.txt",
                              col_names = c("id"),
                              col_types = cols(.default = col_integer()))

\#get test measurement data
testData <- read_table("UCI HAR Dataset/test/X_test.txt", 
                       col_types = cols(.default = col_double()),
                       col_names = FALSE,
                       progress = FALSE)

names(testData)<-features$name

\#bind subject, activity and data
testData <- cbind(testSubjects, testActivities, testData)

\#bind test an training data
totalData <- rbind(trainData, testData)
```


2) Extracts only the measurements on the mean and standard deviation for each measurement
```
dataToRetrieve <- grepl("((mean|std)[(][)])|id|subject", names(totalData))
totalData <- totalData[,dataToRetrieve]
```

3) Uses descriptive activity names to name the activities in the data set
```
totalData <- merge(activities, totalData, by.x="id", by.y = "id", all = TRUE)
totalData$id <- NULL
totalData$subject <- as.factor(totalData$subject)
totalData$activity <- as.factor(totalData$activity)
```

4) Appropriately labels the data set with descriptive variable names.
```
names(totalData)<-gsub("^t", "Time", names(totalData))
names(totalData)<-gsub("^f", "Frequency", names(totalData))
names(totalData)<-gsub("BodyBody", "Body", names(totalData), fixed = TRUE)
names(totalData)<-gsub("Acc", "LinearAcceleration", names(totalData), fixed=TRUE)
names(totalData)<-gsub("Gyro", "AngularVelocity", names(totalData), fixed=TRUE)
names(totalData)<-gsub("mean()", "Mean", names(totalData), fixed=TRUE)
names(totalData)<-gsub("std()", "StandardDeviation", names(totalData), fixed=TRUE)
names(totalData)<-gsub("Mag", "Magnitude", names(totalData), fixed=TRUE)
names(totalData)<-gsub("-", "", names(totalData), fixed=TRUE)
```

5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```
\#calculate the mean
totalData <- totalData %>% 
  group_by(activity, subject) %>%
  summarize_each(funs(mean)) 

\#tidy the data
totalData <- gather(totalData, feature, mean, -subject, -activity)

\#save the tidy data
write.table(totalData, row.names = FALSE, file = "tidydata.txt")
```

##VARIABLES

###Activity: 
	Name of the activity the subject was carrying out when the measurements were made. The possible values are:
	-LAYING
	-SITTING
	-STANDING
	-WALKING
	-WALKING_DOWNSTAIRS
	-WALKING_UPSTAIRS

###Subject Identification: 
	Identification number of each subject, ranging from 1 to 30.
	
###Feature:
	All features measured or derived from the original data:
	-TimeBodyLinearAccelerationMeanX
	-TimeBodyLinearAccelerationMeanZ
	-TimeBodyLinearAccelerationStandardDeviationY
	-TimeGravityLinearAccelerationMeanX
	-TimeGravityLinearAccelerationMeanZ
	-TimeGravityLinearAccelerationStandardDeviationY
	-TimeBodyLinearAccelerationJerkMeanX
	-TimeBodyLinearAccelerationJerkMeanZ
	-TimeBodyLinearAccelerationJerkStandardDeviationY
	-TimeBodyAngularVelocityMeanX
	-TimeBodyAngularVelocityMeanZ
	-TimeBodyAngularVelocityStandardDeviationY
	-TimeBodyAngularVelocityJerkMeanX
	-TimeBodyAngularVelocityJerkMeanZ
	-TimeBodyAngularVelocityJerkStandardDeviationY
	-TimeBodyLinearAccelerationMagnitudeMean
	-TimeGravityLinearAccelerationMagnitudeMean
	-TimeBodyLinearAccelerationJerkMagnitudeMean
	-TimeBodyAngularVelocityMagnitudeMean
	-TimeBodyAngularVelocityJerkMagnitudeMean
	-FrequencyBodyLinearAccelerationMeanX
	-FrequencyBodyLinearAccelerationMeanZ
	-FrequencyBodyLinearAccelerationStandardDeviationY
	-FrequencyBodyLinearAccelerationJerkMeanX
	-FrequencyBodyLinearAccelerationJerkMeanZ
	-FrequencyBodyLinearAccelerationJerkStandardDeviationY
	-FrequencyBodyAngularVelocityMeanX
	-FrequencyBodyAngularVelocityMeanZ
	-FrequencyBodyAngularVelocityStandardDeviationY
	-FrequencyBodyLinearAccelerationMagnitudeMean
	-FrequencyBodyLinearAccelerationJerkMagnitudeMean
	-FrequencyBodyAngularVelocityMagnitudeMean
	-FrequencyBodyAngularVelocityJerkMagnitudeMean
	-TimeBodyLinearAccelerationMeanY
	-TimeBodyLinearAccelerationStandardDeviationX
	-TimeBodyLinearAccelerationStandardDeviationZ
	-TimeGravityLinearAccelerationMeanY
	-TimeGravityLinearAccelerationStandardDeviationX
	-TimeGravityLinearAccelerationStandardDeviationZ
	-TimeBodyLinearAccelerationJerkMeanY
	-TimeBodyLinearAccelerationJerkStandardDeviationX
	-TimeBodyLinearAccelerationJerkStandardDeviationZ
	-TimeBodyAngularVelocityMeanY
	-TimeBodyAngularVelocityStandardDeviationX
	-TimeBodyAngularVelocityStandardDeviationZ
	-TimeBodyAngularVelocityJerkMeanY
	-TimeBodyAngularVelocityJerkStandardDeviationX
	-TimeBodyAngularVelocityJerkStandardDeviationZ
	-TimeBodyLinearAccelerationMagnitudeStandardDeviation
	-TimeGravityLinearAccelerationMagnitudeStandardDeviation
	-TimeBodyLinearAccelerationJerkMagnitudeStandardDeviation
	-TimeBodyAngularVelocityMagnitudeStandardDeviation
	-TimeBodyAngularVelocityJerkMagnitudeStandardDeviation
	-FrequencyBodyLinearAccelerationMeanY
	-FrequencyBodyLinearAccelerationStandardDeviationX
	-FrequencyBodyLinearAccelerationStandardDeviationZ
	-FrequencyBodyLinearAccelerationJerkMeanY
	-FrequencyBodyLinearAccelerationJerkStandardDeviationX
	-FrequencyBodyLinearAccelerationJerkStandardDeviationZ
	-FrequencyBodyAngularVelocityMeanY
	-FrequencyBodyAngularVelocityStandardDeviationX
	-FrequencyBodyAngularVelocityStandardDeviationZ
	-FrequencyBodyLinearAccelerationMagnitudeStandardDeviation
	-FrequencyBodyLinearAccelerationJerkMagnitudeStandardDeviation-
	-FrequencyBodyAngularVelocityMagnitudeStandardDeviation
	-FrequencyBodyAngularVelocityJerkMagnitudeStandardDeviation

###Mean:
	The average of each variable for each activity and each subject
