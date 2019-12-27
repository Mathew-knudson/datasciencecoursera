#Load libraries to be used

library(readr)
library(dplyr)
library(tidyr)

#import the test and training data, the list of variable names, and assign variable names to data
X_test <- read_table("UCI HAR Dataset/test/X_test.txt",col_names =FALSE)
X_train <- read_table("UCI HAR Dataset/train/X_train.txt",col_names=FALSE)
X_vars <- read_csv("UCI HAR Dataset/features.txt",col_names=FALSE)
colnames(X_test)<-X_vars$X1
colnames(X_train)<-X_vars$X1

#import the labels,append to data.
y_train <- read_csv("UCI HAR Dataset/train/y_train.txt",col_names=FALSE)
y_test <- read_csv("UCI HAR Dataset/test/y_test.txt",col_names=FALSE)

X_train$label <- y_train$X1
X_test$label <- y_test$X1

#import the subjects, append to data.

subject_train <-read_csv("UCI HAR Dataset/train/subject_train.txt",col_names=FALSE)
subject_test <-read_csv("UCI HAR Dataset/test/subject_test.txt",col_names=FALSE)

X_train$subject <- subject_train$X1
X_test$subject <- subject_test$X1


#combine the two datasets
dataset <- rbind(X_train,X_test)

#select only the columns that are means or standard deviations as specified in dataset readme
dataset <- select(dataset, matches("mean\\(\\)|std\\(\\)|label|subject",ignore.case = FALSE))

#Provide Descriptive Activity Labels
dataset$label <- factor(dataset$label, labels = c("Walking","Walking_Upstairs","Walking_Downstairs","Sitting","Standing","Laying"))
#group by subject and activity
dataset <- group_by(dataset,label,subject)
#create final output
tidydataset <- summarize_all(dataset,funs(mean))
write.csv(tidydataset, file="tidydata.csv")
