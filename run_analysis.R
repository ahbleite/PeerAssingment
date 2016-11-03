#Check if library is installed if not install it
if("readr" %in% rownames(installed.packages()) == FALSE) {install.packages("readr")}
library(readr)
if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr")}
library(dplyr)
if("tidyr" %in% rownames(installed.packages()) == FALSE) {install.packages("tidyr")}
library(tidyr)

#Download the file if it does not exist
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("UCIHARDataset.zip")) {
  download.file(url, destfile="UCIHARDataset.zip")
}
if (!file.exists("UCI HAR Dataset")) {
  unzip("UCIHARDataset.zip")
}

# 1 - Merges the training and the test sets to create one data set.
#get the features
features <- read_delim("UCI HAR Dataset/features.txt", 
                       delim = " ",
                       col_names = c("id", "name"))

#get the activities
activities <- read_table("UCI HAR Dataset/activity_labels.txt", 
                         col_names = c("id", "activity"))

#get training subject data
trainSubjects <- read_table("UCI HAR Dataset/train/subject_train.txt",
                            col_names = c("subject"),
                            col_types = cols(.default = col_integer()))

#get training activities data
trainActivities <- read_table("UCI HAR Dataset/train/y_train.txt",
                              col_names = c("id"),
                              col_types = cols(.default = col_integer()))

#get training measurement data
trainData <- read_table("UCI HAR Dataset/train/X_train.txt", 
                        col_types = cols(.default = col_double()),
                        col_names = FALSE,
                        progress = FALSE)

names(trainData)<-features$name

#bind subject, activity and data
trainData <- cbind(trainSubjects, trainActivities, trainData)

#get test subject data
testSubjects <- read_table("UCI HAR Dataset/test/subject_test.txt",
                            col_names = c("subject"),
                            col_types = cols(.default = col_integer()))

#get test activities data
testActivities <- read_table("UCI HAR Dataset/test/y_test.txt",
                              col_names = c("id"),
                              col_types = cols(.default = col_integer()))

#get test measurement data
testData <- read_table("UCI HAR Dataset/test/X_test.txt", 
                       col_types = cols(.default = col_double()),
                       col_names = FALSE,
                       progress = FALSE)

names(testData)<-features$name

#bind subject, activity and data
testData <- cbind(testSubjects, testActivities, testData)

#bind test an training data
totalData <- rbind(trainData, testData)

# 2 - Extracts only the totalData on the mean and standard deviation for each measurement.
dataToRetrieve <- grepl("((mean|std)[(][)])|id|subject", names(totalData))
totalData <- totalData[,dataToRetrieve]

# 3 - Uses descriptive activity names to name the activities in the data set
totalData <- merge(activities, totalData, by.x="id", by.y = "id", all = TRUE)
totalData$id <- NULL
totalData$subject <- as.factor(totalData$subject)
totalData$activity <- as.factor(totalData$activity)

# 4 - Appropriately labels the data set with descriptive variable names.
names(totalData)<-gsub("^t", "Time", names(totalData))
names(totalData)<-gsub("^f", "Frequency", names(totalData))
names(totalData)<-gsub("BodyBody", "Body", names(totalData), fixed = TRUE)
names(totalData)<-gsub("Acc", "LinearAcceleration", names(totalData), fixed=TRUE)
names(totalData)<-gsub("Gyro", "AngularVelocity", names(totalData), fixed=TRUE)
names(totalData)<-gsub("mean()", "Mean", names(totalData), fixed=TRUE)
names(totalData)<-gsub("std()", "StandardDeviation", names(totalData), fixed=TRUE)
names(totalData)<-gsub("Mag", "Magnitude", names(totalData), fixed=TRUE)
names(totalData)<-gsub("-", "", names(totalData), fixed=TRUE)

# 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#calculate the mean
totalData <- totalData %>% 
  group_by(activity, subject) %>%
  summarize_each(funs(mean)) 

#tidy the data
totalData <- gather(totalData, feature, mean, -subject, -activity)

#save the tidy data
write.table(totalData, row.names = FALSE, file = "tidydata.txt")



