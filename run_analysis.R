#set working directory to local folder
setwd("C:/Users/Laptop/Desktop/data scientist track/3. Getting and Cleaning data")
#read test data
Test.Subject <- read.table("project/test/subject_test.txt", header = FALSE)
Test.Activity <- read.table("project/test/y_test.txt", header = FALSE)
Test.Feature <- read.table("project/test/X_test.txt", header = FALSE)
#read training data
Train.Subject <- read.table("project/train/subject_train.txt", header = FALSE)
Train.Activity <- read.table("project/train/y_train.txt", header = FALSE)
Train.Feature <- read.table("project/train/X_train.txt", header = FALSE)
#read activity and feature names
Feature.Name <- read.table("project/features.txt")
Activity.Labels <- read.table("project/activity_labels.txt", header = FALSE)

##1. Merge training and test data set
Subject <- rbind(Train.Subject, Test.Subject)
Activity <- rbind(Train.Activity, Test.Activity)
Feature <- rbind(Train.Feature, Test.Feature)
mydata <- cbind(Subject, Activity, Feature)

##2. Extracts only the measurements on the mean and standard deviation for each measurement
names(Feature) <- Feature.Name[,2]
Mean.Std <- sqldf("select V2 from [Feature.Name] where V2 like '%mean%' OR V2 like '%std%'")
mydata1 <- cbind(Subject, Activity, mydata[,as.vector(t(Mean.Std))])

##3. Uses descriptive activity names to name the activities in the data set
names(Activity) <- "Activity"
for (i in 1:6){
  mydata1$Activity[mydata1$Activity == i] <- as.character(Activity.Labels[i,2])
}
mydata1$Activity <- as.factor(mydata1$Activity)

##4. Appropriately labels the data set with descriptive variable names
names(Subject) <- "Subject"
### Look at all column names
names(mydata1)


##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(data.table)
mydata2 <- data.table(mydata1)
Tidy.Dataset <- aggregate(. ~Subject + Activity, mydata2, mean)
Tidy.Dataset <- Tidy.Dataset[order(Tidy.Dataset$Subject,Tidy.Dataset$Activity),]
write.table(Tidy.Dataset, file = "Tidy.Dataset.txt", row.names = FALSE)
