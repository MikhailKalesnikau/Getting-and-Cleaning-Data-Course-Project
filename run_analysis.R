# -----------------------------------------------------------------------------
# Getting and Cleaning Data - Course Project
#
# Author: Mikhail Kalesnikau
#
# This R script called run_analysis.R does the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# -----------------------------------------------------------------------------
# install required packages
if (!require("data.table")) {
	install.packages("data.table")
}
require("data.table")

if (!require("reshape2")) {
	install.packages("reshape2")
}
require("reshape2")

# -----------------------------------------------------------------------------
# download raw data archive
filePath <- "./getdata-projectfiles-UCI HAR Dataset.zip"
if (!file.exists(filePath)) {
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    message("Downloading raw data archive...")
    download.file(url = fileURL, destfile = filePath)
}

# extract raw data from the archive
message("Extracting raw data files from the archive...")
unzip(zipfile = filePath)

folderPath <- "./UCI HAR Dataset"

# -----------------------------------------------------------------------------
# read activity labels
activity_labels <- read.table(paste(folderPath, "activity_labels.txt", sep="/"))[,2]

# read features
features <- read.table(paste(folderPath, "features.txt", sep="/"))[,2]

# create the mask on the mean and standard deviation features
mask_features <- grepl("mean|std", features)

# -----------------------------------------------------------------------------
# read test set
X_test <- read.table(paste(folderPath, "test", "X_test.txt", sep="/"))
y_test <- read.table(paste(folderPath, "test", "y_test.txt", sep="/"))
subject_test <- read.table(paste(folderPath, "test", "subject_test.txt", sep="/"))

names(X_test) = features

# extract only the measurements on the mean and standard deviation for each measurement
X_test = X_test[, mask_features]

# add activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("activity_id", "activity_label")
names(subject_test) = "subject"

# bind test set
test_set <- cbind(as.data.table(subject_test), y_test, X_test)

# -----------------------------------------------------------------------------
# read train set
X_train <- read.table(paste(folderPath, "train", "X_train.txt", sep="/"))
y_train <- read.table(paste(folderPath, "train", "y_train.txt", sep="/"))
subject_train <- read.table(paste(folderPath, "train", "subject_train.txt", sep="/"))

names(X_train) = features

# extract only the measurements on the mean and standard deviation for each measurement
X_train = X_train[, mask_features]

# add activity labels
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("activity_id", "activity_label")
names(subject_train) = "subject"

# bind train set
train_set <- cbind(as.data.table(subject_train), y_train, X_train)

# -----------------------------------------------------------------------------
# merge the training and the test sets to create one data set
data = rbind(test_set, train_set)

# -----------------------------------------------------------------------------
# create a second, independent tidy data set with the average of each variable for each activity and each subject
id_labels = c("subject", "activity_id", "activity_label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id.vars = id_labels, measure.vars = data_labels)

tidy_set = dcast(melt_data, subject + activity_label ~ variable, mean)

# write the tidy data set into ./tidy_set.txt
write.table(tidy_set, file = "./tidy_set.txt", row.names = FALSE)
message("Tidy data set successfully created in ./tidy_set.txt")
