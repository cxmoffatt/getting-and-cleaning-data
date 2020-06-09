##load dplyr library
library(dplyr)


##download zip file, if it does not already exist
filename <- "Data.zip"
if(!file.exists(filename)) {
  data_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(data_url, filename, method = "curl")
}

##unzip file, if it has not already been unzipped
datapath <- "UCI HAR Dataset"
if(!file.exists(datapath)) {
  unzip(filename)
}

##read test data
testsubjects <- read.table(file.path(datapath, "test", "subject_test.txt"), col.names = "subject")
testdata <- read.table(file.path(datapath, "test", "X_test.txt"))
testlabels <- read.table(file.path(datapath, "test", "y_test.txt"), col.names = "activity")

##read training data
trainsubjects <- read.table(file.path(datapath, "train", "subject_train.txt"), col.names = "subject")
traindata <- read.table(file.path(datapath, "train", "X_train.txt"))
trainlabels <- read.table(file.path(datapath, "train", "y_train.txt"), col.names = "activity")

##read activity labels
activities <- read.table(file.path(datapath, "activity_labels.txt"), col.names = c("num", "activity"))

##read features labels
features <- read.table(file.path(datapath, "features.txt"), col.names = c("num", "feature"))

##merge training and test data
combined_data <- rbind(testdata, traindata)
colnames(combined_data) <- features$feature
combined_subjects <- rbind(testsubjects, trainsubjects)
combined_labels <- rbind(testlabels, trainlabels)

##merge data, subjects and labels into combined df
combined_df <- cbind(combined_subjects, combined_labels, combined_data)

##indices of features list containing mean or std
meanstd_index <- grep("mean|std", features$feature)

##only keep columns containing mean or std
tidy_df <- select(combined_df, subject, activity, matches("mean|std"))

#associate activity numbers with their descriptive labels
tidy_df$activity <- factor(tidy_df$activity, activities$num, activities$activity)

##clean up variable names by substitution
names(tidy_df) <- gsub("^t", "Time", names(tidy_df))
names(tidy_df) <- gsub("^f", "Frequency", names(tidy_df))
names(tidy_df) <- gsub("Acc", "Accelerometer", names(tidy_df))
names(tidy_df) <- gsub("Gyro", "Gyroscope", names(tidy_df))
names(tidy_df) <- gsub("Mag", "Magnitude", names(tidy_df))
names(tidy_df) <- gsub("BodyBody", "Body", names(tidy_df))
names(tidy_df) <- gsub("mean()", "Mean", names(tidy_df))
names(tidy_df) <- gsub("std()", "StDev", names(tidy_df))

##group data by activity and subject
means_df <- tidy_df %>% 
  group_by(subject, activity) %>%
  summarise_all(funs(mean))

#writes final tidy means df to a txt file
write.table(means_df, "tidy_data.txt", row.name = FALSE)




