library(downloader)
library(tidyr)
library(dplyr)
library(plyr)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
setwd("/Users/hcam/Desktop/Coursera/GCD")
download(url, dest="dataset.zip", mode="wb") 
unzip ("dataset.zip", exdir = "./")

#reads train data
xTrain <- tbl_df(read.table("UCI HAR Dataset/train/X_train.txt"))
yTrain <- tbl_df(read.table("UCI HAR Dataset/train/y_train.txt"))
subTrain <- tbl_df(read.table("UCI HAR Dataset/train/subject_train.txt"))

#reads test data
xTest <- tbl_df(read.table("UCI HAR Dataset/test/X_test.txt"))
yTest <- tbl_df(read.table("UCI HAR Dataset/test/y_test.txt"))
subTest <- tbl_df(read.table("UCI HAR Dataset/test/subject_test.txt"))

#reads features and activities
features <- read.table("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
activity <- read.table("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)

# Extract only the data on mean and standard deviation
filteredFeatures <- grep(".*mean.*|.*std.*", features[,2])

#combining train and test data
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
subData <- rbind(subTrain, subTest)

#renaming xData
xData <- xData[, filteredFeatures]
names(xData) <- features[filteredFeatures, 2]

#matching activity to yData
yData$Activity <- activity$V2[match(yData$V1, activity$V1)]

#combining all data
UCIdata <- cbind(yData[,2], subData, xData)
colnames(UCIdata)[2] <- "Subject"
#generate tidy data set with average of subject and activity
UCIdatatidy<- ddply(UCIdata, c("Subject","Activity"), numcolwise(mean))
#save data file
write.table(UCIdatatidy, "UCIdatatidy.txt", row.names = FALSE, quote = FALSE)
