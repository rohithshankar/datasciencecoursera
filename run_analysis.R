
# 1. Merges the training and the test sets to create one dataset

#read the features file and assign proper column names
features <- read.table("UCI HAR Dataset/features.txt", sep=" ", col.names = c("x","functions_used"))

#read the activity file and assign proper column names
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", sep=" ", col.names = c("code","activity_label"))

#read the train subject file and assign proper column names
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#read the test subject file and assign proper column names
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")

#read the y train file and assign proper column names
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names ="code")

#read the x train file and assign proper column names
x_train <- read.table("UCI HAR Dataset/train/x_train.txt", col.names=features$functions_used)

#read the x test file and assign proper column names
x_test <- read.table("UCI HAR Dataset/test/x_test.txt", col.names=features$functions_used)

#read the y test file and assign proper column names
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names ="code")

# union the train and text x files
x <- rbind(x_train, x_test);

# union the train and text y files
y <- rbind(y_train, y_test);

# union the train and test subject files
subject <- rbind(subject_train, subject_test);

# join the x,y and subject files
mergedData <-cbind(subject,x,y);


#2. Extract only measurements on the mean and standard deviation for each measurement

library(dplyr)

#extract only those columns that have are mean or standard deviantions
meanSubset1<-select(mergedData,subject, code, contains("mean"), contains("std"));

#join mean/std data with the activity subset
mergedData1<-select(merge(meanSubset1, activity_labels, by.x="code", by.y="code"),-code)


#review the names of the metric columns
names(mergedData1)

#repalce the cryptic variable names with descripitive names
names(mergedData1)<-gsub("Acc", "Accelerometer", names(mergedData1))
names(mergedData1)<-gsub("Gyro", "Gyroscope", names(mergedData1))
names(mergedData1)<-gsub("BodyBody", "Body", names(mergedData1))
names(mergedData1)<-gsub("Mag", "Magnitude", names(mergedData1))
names(mergedData1)<-gsub("^t", "Time", names(mergedData1))
names(mergedData1)<-gsub("-freq()", "Frequency", names(mergedData1))
names(mergedData1)<-gsub("angle", "Angle", names(mergedData1))
names(mergedData1)<-gsub("gravity", "Gravity", names(mergedData1))
names(mergedData1)<-gsub("^f", "Freuqency", names(mergedData1))
names(mergedData1)<-gsub("^tBody", "TimeBody", names(mergedData1))
names(mergedData1)<-gsub("-mean()", "Mean", names(mergedData1))
names(mergedData1)<-gsub("-std", "STD", names(mergedData1))

#creates a second, independent tidy data set with the average of each variable for each activity and each subject.
summarise_all(group_by(mergedData1, subject, activity_label), funs(mean))

write.table(mergedData1, "SummarizedActivityData.txt")















