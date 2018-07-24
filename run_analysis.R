library(tidyverse)
setwd("D:/JH_data_science/getdata_projectfiles_UCI HAR Dataset") # unzipped

# read in files:
x.train <- read.table("./UCI HAR Dataset/train/X_train.txt")
x.test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y.train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
y.test<- read.table("./UCI HAR Dataset/test/Y_test.txt")
subject.train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject.test  <- read.table("./UCI HAR Dataset/test/subject_test.txt")
activity.label <- read.table("./UCI HAR Dataset/activity_labels.txt")
features.name  <- read.table("./UCI HAR Dataset/features.txt")

# 1. merge the training and test sets to create one dataset
 # merging the Feature Data
feature.data <- rbind(x.train, x.test)
 # merging the Activity Data
activity.data <- rbind(y.train, y.test)
 # merging Subject data
subject.data <- rbind(subject.train, subject.test)
rm(x.train, x.test, y.train, y.test, subject.train, subject.test)
 # set names to variables
names(subject.data) <- "subject"
names(activity.data) <- "activity"
names(feature.data) <- features.name$V2
 # merding all datas in one
all.data <- cbind(feature.data, activity.data, subject.data)

# 2. Extract only the measurements on the mean and standard deviation for each measurement
 # get only columns with mean() or std() in their names
mean.std.features <- features.name$V2[grep("mean|std", 
                                           features.name$V2)]
 # subset the desired columns
selected.columns <- c(as.character(mean.std.features), "subject", "activity" )
all.data <- subset(all.data, select = selected.columns)

# 3. Use descriptive activity names to name the activities in the dataset
 # update values with correct activity names
all.data$activity <- activity.label[all.data$activity, 2]

# 4. Appropriately label the data set with descriptive variable names
names(all.data) <- gsub("^t", "time", names(all.data))
names(all.data) <- gsub("^f", "frequency", names(all.data))
names(all.data) <- gsub("Acc", "Accelerometer", names(all.data))
names(all.data) <- gsub("Gyro", "Gyroscope", names(all.data))
names(all.data) <- gsub("Mag", "Magnitude", names(all.data))
names(all.data) <- gsub("BodyBody", "Body", names(all.data))

# 5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
final.data <- all.data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
write.table(final.data, "tidy.txt", row.name = FALSE)
