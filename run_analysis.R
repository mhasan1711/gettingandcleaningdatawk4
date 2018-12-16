library(dplyr)

dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dataset <- "UCI HAR Dataset.zip"

if (!file.exists(dataset)) {
  download.file(dataUrl, dataset)
}

# unzip file containing data and create directory if data directory doesn't already exist
dataPath <- "UCI HAR Dataset"
if (!file.exists(dataPath)) {
  unzip(dataset)
}
#Load Train Data
trainX <- read.table(file.path(dataPath,'train','X_train.txt'))
trainY <- read.table(file.path(dataPath,'train','Y_train.txt'))
subTrain <- read.table(file.path(dataPath,'train','subject_train.txt'))
#Merge train data Column wise
mergeTrain <- cbind(trainX, trainY,subTrain)

#Load Test Data
testX <- read.table(file.path(dataPath,'test','X_test.txt'))
testY <- read.table(file.path(dataPath,'test','Y_test.txt'))
subTest <- read.table(file.path(dataPath,'test','subject_test.txt'))

#Merge test data Column wise
mergeTest <- cbind(testX, testY,subTest)

# Combine train and test data sets to form the complete data set using rbind
fullDataSet <- rbind(mergeTrain, mergeTest)


#load features dataset and use descriptive column names
features <- read.table(file.path(dataPath,'features.txt'))
colnames(features) <- c('FeatureID','Feature')
featureVector <- as.character(features$Feature)
dataSetColNames <- c(featureVector,'ActivityID','Subject')
colnames(fullDataSet) <- dataSetColNames
#load activity dataset and use descriptive column names
activity <- read.table(file.path(dataPath,'activity_labels.txt'))
colnames(activity) <- c('ActivityID','Activity')

# Merge Full Data set with Activity on ActivityID Column to get the Activity Description
fullDataSetActivity <- merge(fullDataSet, activity, by = 'ActivityID')

# Filter features by Mean or Standard Deviation
filteredFeatures <- grep('[Mm]ean|[Ss]td', featureVector, value = TRUE)

columnstoSelect <- c('Activity','Subject',filteredFeatures)

finalDataSet <- fullDataSetActivity[,columnstoSelect]

# Make column names Tidy Data Compliant
finalDataSetCols <- colnames(finalDataSet)
# recursively remove special characters
finalDataSetCols <- gsub("[\\(\\)-]", "", finalDataSetCols)
#Use the definition provided in the feature_info.txt to replace single characters and acronyms 
finalDataSetCols <- sub("^f", "frequencyDomain", finalDataSetCols)
finalDataSetCols <- sub("^t", "timeDomain", finalDataSetCols)
finalDataSetCols <- sub("Acc", "Accelerometer", finalDataSetCols)
finalDataSetCols <- sub("Mag", "Magnitude", finalDataSetCols)

# recursively fix BodyBody to Body
finalDataSetCols <- gsub("BodyBody", "Body", finalDataSetCols)
# Make Column Names with Mean and Std more verbose and proper cased
finalDataSetCols <- gsub("mean", "Mean", finalDataSetCols)
finalDataSetCols <- gsub("std", "StandardDeviation", finalDataSetCols)

colnames(finalDataSet) <- finalDataSetCols

# Make a copy of finalDataSet to group by Activity, Subject and calculate Averages for each variable
myDF <- finalDataSet[,]
myDFMean <- myDF %>% group_by(Activity, Subject) %>% summarize_all(funs(mean))
#Write to the file
write.table(myDFMean, file = 'tidyData.txt', row.names = FALSE)

