library(dplyr)


# getting the data (downloading zipfiles and extracting)
if(!file.exists("./data")){dir.create("./data")}
        fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")        
unzip(zipfile = "./data/Dataset.zip",exdir = "./data")

#-------------------------------------------------------------------------------------------------------------------------------------
# 1) Mergeing the training and the test sets to create one data set:

        #   reading  test data sets:
x_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
        #   reading train data sets:
x_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
        #  reading feature vector:
features <- read.table("./data/UCI HAR Dataset/features.txt")
        #  reading activity labels:
activities = read.table("./data/UCI HAR Dataset/activity_labels.txt")
        #   merging data sets


        #   assigning variable names
colnames(x_train) <- features[,2] 
colnames(x_test) <- features[,2] 

colnames(y_train) <-"activity"
colnames(y_test) <- "activity"


colnames(subject_train) <- "subject"
colnames(subject_test) <- "subject"

colnames(activities) <- c("activity", "activityLabel")

activityData<-rbind(cbind(subject_train,y_train,x_train),cbind(subject_test,y_test,x_test))
#-------------------------------------------------------------------------------------------------------------------------------------
# 2) Extracting the measurements on the mean and standard deviation for each measurement:


c <- grepl("subject|activity|mean|std", colnames(activityData))
activityData <- activityData[, c]

DataColName<-colnames(activityData)

#-------------------------------------------------------------------------------------------------------------------------------------
# 3) Useing descriptive activity names to name the activities in the data set:
activityData$activity <- factor(activityData$activity,levels = activities[, 1], labels = activities[, 2])

#-------------------------------------------------------------------------------------------------------------------------------------
# 4) Using appropriate labels the data set with descriptive variable names:

DataColName<-gsub("\\(\\)","",DataColName)
DataColName<-gsub("-mean","Mean",DataColName)
DataColName<-gsub("-std","Sd",DataColName)
DataColName<-gsub("tBody","TimeBody",DataColName)
DataColName<-gsub("tGravity","TimeGravity",DataColName)
DataColName<-gsub("fBody","FreqBody",DataColName)
DataColName<-gsub("fGravity","FreqGravity",DataColName)
DataColName<-gsub("BodyBody","Body",DataColName)
DataColName<-gsub("Mag","Magnitude",DataColName)

colnames(activityData)<-DataColName

#-------------------------------------------------------------------------------------------------------------------------------------
#5) Tidy data set with the average of each variable for each activity and each subject:
DataActivityMean <- activityData %>% group_by(subject, activity) %>% summarise_all(funs(mean))
write.table(activityData, "tidy_data.txt", row.names = FALSE, quote = FALSE)
