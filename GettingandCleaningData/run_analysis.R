## You should create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
if (!require(data.table))
{
  install.packages("data.table")
}
if (!require("reshape2"))
{
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Read activity labels
activitylabels <- read.table("./UCI HAR Dataset/Activity_labels.txt")[,2]

# Read data column labels
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Measurements on the mean and standard deviation for each measurement.
featuresextract <- grepl("mean|std", features)

# Read x Test & Y Test data
Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")

subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(Xtest) = features

# Extract measurements on the mean and standard deviation for each measurement.
Xtest = Xtest[,featuresextract]


# activity
ytest[,2] = activitylabels[ytest[,1]]
names(ytest) = c("Activity_ID","Activity_Label")
names(subjecttest) = "subject"

# Bind data
testdata <- cbind(as.data.table(subjecttest),ytest,Xtest)

# Read process X train and y train data
Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subjecttrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(Xtrain) = features

# Measurements on the mean and standard deviation for each measurement
Xtrain = Xtrain[,featuresextract]

# activity data
ytrain[,2] = activitylabels[ytrain[,1]]
names(ytrain) = c("Activity_ID","Activity_Label")
names(subjecttrain) = "subject"

# Bind data
traindata <- cbind(as.data.table(subjecttrain),ytrain,Xtrain)

# Merge test and train data
data = rbind(testdata,traindata)

id = c("subject","Activity_ID","Activity_Label")
datalabels = setdiff(colnames(data),id)
meltdata = melt(data,id = id, measure.vars = datalabels)


# Apply mean function to dataset using dcast function
tidydata = dcast(meltdata,subject + Activity_Label ~ variable, mean)

write.table(tidydata, file = "./tidydata.txt")