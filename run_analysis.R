train_data <- read.table(file = "C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/train/X_train.txt", header = FALSE)

test_data <- read.table(file = "C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/X_test.txt", header = FALSE)

features <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)

subject <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors=FALSE)

train_data <- cbind(train_data, subject)

activity <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/train/y_train.txt", stringsAsFactors=FALSE)

train_data <- cbind(train_data, activity)

subject <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors=FALSE)

test_data <- cbind(test_data, subject)

activity <- read.table("C:/Users/Mohamed Hassan/Desktop/UCI HAR Dataset/test/y_test.txt", stringsAsFactors=FALSE)

test_data <- cbind(test_data, activity)

all_data <- rbind(train_data, test_data)

features <- rbind(features, "Subject")

features <- rbind(features, "Activity")

names(all_data) <- features[,2]

mean_std <- subset(all_data, select = grep("*mean*|*std*|Subject|Activity", names(all_data)))

all_data$Activity <- as.factor(all_data$Activity)

all_data$Subject <- as.factor(all_data$Subject)

grouped_data <- group_by(all_data, Subject, Activity)

summarise(grouped_data)