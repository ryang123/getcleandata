run_analysis <- function() 
{
  
  library(data.table)
  library(dplyr)
    
  ## Read the input files
  print("Reading features and activity data")
  featurenames <- read.table("features.txt")
  activitylabels <- read.table("activity_labels.txt", header = FALSE) 
  
  print("Reading training data")
  trainingsubjects <- read.table("train/subject_train.txt", header = FALSE)
  trainingset <- read.table("train/X_train.txt", header = FALSE)
  traininglabels <- read.table("train/y_train.txt", header = FALSE)
  
  print("Reading test data")
  testsubjects <- read.table("test/subject_test.txt", header = FALSE)
  testset <- read.table("test/X_test.txt", header = FALSE)
  testlabels <- read.table("test/y_test.txt", header = FALSE)
  
  ## Binding training and test values
  subject <- rbind(trainingsubjects, testsubjects)
  activity <- rbind(traininglabels, testlabels)
  features <- rbind(trainingset, testset)
  
  ## Setting columns names
  colnames(features) <- t(featurenames[2])
  colnames(activity) <- "Activity"
  colnames(subject) <- "Subject"
  
  ## Binding features, activity, and subject data
  allvalues <- cbind(features,activity,subject)
  
  ## Search for column names with measures of interest, get those indices and extract that data to new variable
  ## Make sure to include activity and subject!
  columnswithmeasures <- grep(".*Mean.*|.*Std.*", names(allvalues), ignore.case=TRUE)
  keepcolumns <- c(columnswithmeasures, 562, 563)
  subsetdata <- allvalues[,keepcolumns]
  
  ## Set activity from activity labels
  subsetdata$Activity <- as.character(subsetdata$Activity)
  for (i in 1:6){
    subsetdata$Activity[subsetdata$Activity == i] <- as.character(activitylabels[i,2])
  }
  subsetdata$Activity <- as.factor(subsetdata$Activity)
  
  ## Now we set the names for the measures to more understandable values
  names(subsetdata)<-gsub("Acc", "Accelerometer", names(subsetdata))
  names(subsetdata)<-gsub("Gyro", "Gyroscope", names(subsetdata))
  names(subsetdata)<-gsub("BodyBody", "Body", names(subsetdata))
  names(subsetdata)<-gsub("Mag", "Magnitude", names(subsetdata))
  names(subsetdata)<-gsub("^t", "Time", names(subsetdata))
  names(subsetdata)<-gsub("^f", "Frequency", names(subsetdata))
  names(subsetdata)<-gsub("tBody", "TimeBody", names(subsetdata))
  names(subsetdata)<-gsub("-mean()", "Mean", names(subsetdata), ignore.case = TRUE)
  names(subsetdata)<-gsub("-std()", "STD", names(subsetdata), ignore.case = TRUE)
  names(subsetdata)<-gsub("-freq()", "Frequency", names(subsetdata), ignore.case = TRUE)
  names(subsetdata)<-gsub("angle", "Angle", names(subsetdata))
  names(subsetdata)<-gsub("gravity", "Gravity", names(subsetdata))
  
  subsetdata$Subject <- as.factor(subsetdata$Subject)
  subsetdata <- data.table(subsetdata)
  
  ## Write the tidy data set to a file
  tidydata <- aggregate(. ~Subject + Activity, subsetdata, mean)
  tidydata <- tidydata[order(tidydata$Subject,tidydata$Activity),]
  write.table(tidydata, file = "tidy.txt", row.names = FALSE)

}
