require(data.table)
require(dplyr)
## Call file locally or download it (assuming this is running in a good working directory)
#Also assuming that dataset is present if the 'UCI HAR Dataset' directory exists
if (!dir.exists("UCI HAR Dataset")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile= "UCI HAR Dataset.zip")
  unzip("UCI HAR Dataset.zip")
} 

## Begin reading in information from data folders
feature_names <- read.table("./UCI HAR Dataset/features.txt")["V2"]
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names = c("Label","Activity"))

#Pull in the test features and extract only mean and std values
X_test_full <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = feature_names$V2)
X_test <- subset(X_test_full, select = grep("mean\\.|std\\.", names(X_test_full)))

#Add the corresponding activities
X_test$Activity <- as.numeric(read.table("./UCI HAR Dataset/test/y_test.txt")[,])
#Add the subjects
X_test$Subject <- as.numeric(read.table("./UCI HAR Dataset/test/subject_test.txt")[,])

#Pull in the training features and extract only mean and std values
X_train_full <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names = feature_names$V2)
X_train <- subset(X_train_full, select = grep("mean\\.|std\\.", names(X_train_full)))

#Add the corresponding activities
X_train$Activity <- as.numeric(read.table("./UCI HAR Dataset/train/y_train.txt")[,])
#Add the subjects
X_train$Subject <- as.numeric(read.table("./UCI HAR Dataset/train/subject_train.txt")[,])

#Combine the two datsets into one frame
Full_data <- rbind(X_test,X_train)

#Make activity labels descriptive by making a lookup table and applying it
Activity_lookup <- setNames(as.character(activity_labels$Activity), activity_labels$Labels)
Full_data$Activity <- Activity_lookup[Full_data$Activity]

#Make the consolidated table of averages by subject and activity
Full_data_table <- as.data.table(Full_data)
Consolidated_stats <- Full_data_table %>% group_by(Subject,Activity) %>% summarize_all(funs(mean(.)))