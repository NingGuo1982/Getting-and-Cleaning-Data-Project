##This R Scipt requires the qdap and reshape2 packages to be installed and loaded
##Load features to be used as column names for measurements on test and train
features <- readLines("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
##Load the test and train data with the features as the column names
test <- read.table(file = "C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/X_test.txt", header = FALSE)
train <- read.table(file = "C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/train/X_train.txt", header = FALSE)
##Load the subjects numbers
testSubject <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors=FALSE)
trainSubject <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/subject_train.txt", stringsAsFactors=FALSE)
#Load the activity numbers that we will use to merge the test and train datasets
testActivity <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/y_test.txt", stringsAsFactors=FALSE)
trainActivity <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/y_train.txt", stringsAsFactors=FALSE)
##Column bind the subject numbers to their respective data set
test <- cbind(testSubject, test) ; train <- cbind(trainSubject, train)
##Column bind the activity numbers to their respective data set
test <- cbind(testActivity, test) ; train <- cbind(trainActivity, train)
##Merge the 2 data sets
mergedData <- merge(test, train, all = T)
##Subset columns that calculate mean or standard deviation for each column
##Also subset the activity and subject columns
mergedData <- mergedData[, grepl("activity|subject|[Mm]ean|[Ss]td",
                                 names(mergedData))]
mergedData <- mergedData[, !grepl("angle|meanFreq", names(mergedData))]
##Substitute the activity numbers with descriptive activity names using mgsub()
##in dqap package
activityNumbers <- c("1", "2", "3", "4", "5", "6")
activityNames <- c("walking", "walkingUpstairs", "walkingDownstairs", "sitting",
                   "standing","laying")
if(!require(qdap)) {install.packages("qdap") ; library(qdap)}
mergedData$activity <- mgsub(activityNumbers, activityNames, 
                              mergedData$activity)
##Tidy up variable names by making column names lower case, removing full stops,
##removing the numbers at the beginning and replacing "t"/"f" with "time"/"freq"
colnames(mergedData) <- tolower(colnames(mergedData))
colnames(mergedData) <- gsub(".", "", colnames(mergedData), fixed = T)
colnames(mergedData) <- gsub("^x[0-9]*[0-9]", "", colnames(mergedData))
colnames(mergedData) <- gsub("^t", "time", colnames(mergedData))
colnames(mergedData) <- gsub("^f", "freq", colnames(mergedData))
##Using the reshape2 package, melt the data set and then cast the melted data
##set to summarise the averages of each variable
if(!require(reshape2)) {install.packages("reshape2") ; library(reshape2)}
mergedDataMelt <- melt(mergedData, (id = c("subject", "activity")))
tidyData <- dcast(mergedDataMelt, subject + activity ~ variable, mean)
##Write the tidy data set as a text file in the working directory
write.table(tidyData, file = "tidydata.txt", row.names = F)
