# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

setwd("E:/Coursera/03 - Getting and Cleaning Data/Course Project/")

# Download zip file and unzip it 
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./data/Dataset.zip")) {
  download.file(fileurl, destfile = "projectfiles_dataset.zip")
  unzip("projectfiles_dataset.zip")
}

# Load activity labels; load features dataset
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)[, 2]
features <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)[, 2]
features_mn_sd <- grepl("mean|std|Mean", features)

# Change the features name
features = gsub('-', '_', features)
features = gsub('[()]', '', features)
features = gsub(',', '_', features)

# Loading test data, labels and subject
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

# Loading training data, labels and subject
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
train_set <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

# Create colnames for train and test sets
names(test_set) <- features
names(train_set) <- features

# Extracts only the measurements on the mean and standard deviation for each measurement.
test_set <- test_set[, features_mn_sd]
train_set <- train_set[, features_mn_sd]

# Uses descriptive activity names to name the activities in the data set
test_labels[, 2] <- activity_labels[test_labels[,1]]
names(test_labels) <- c("activity_code", "activity_labels")

train_labels[, 2] <- activity_labels[train_labels[,1]]
names(train_labels) <- c("activity_code", "activity_labels")

# Create names for the columns of other data sets
names(test_subject) <- c("subject")
names(train_subject) <- c("subject")

# Merges the training and the test sets to create one data set.
train_data_set <- cbind(train_subject, train_labels, train_set)
test_data_set <- cbind(test_subject, test_labels, test_set)
data_set <- rbind(train_data_set, test_data_set)

# creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(data.table)
data_set2 <- as.data.table(data_set[, -2]) # eliminate the activity code
tidy <- data_set2[, lapply(.SD, mean), by=list(subject, activity_labels)]

tidy <- tidy[order(tidy$subject, tidy$activity_labels)]
write.table(tidy, file = "tidy_data.txt", row.name=FALSE, quote = FALSE)
