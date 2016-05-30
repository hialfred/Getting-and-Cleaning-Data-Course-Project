# Getting and Cleaning Data Course Project


## 0. Setup/load raw

#download files if not already
if (!file.exists("UCI HAR Dataset")) {
  #download url
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile = "Dataset.zip")
  unzip("Dataset.zip")
}
#read in files
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", header = F)
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", header = F)
subtest <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = F)
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", header = F)
ytrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", header = F)
subtrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = F)

#
#
#
## 1. Merges the training and the test sets to create one data set.

xmerge <- rbind(xtest, xtrain)
ymerge <- rbind(ytest, ytrain)
submerge <- rbind(subtest, subtrain)

#
#
#
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

#prevent reading tables in as levels
options(stringsAsFactors = FALSE)
#read features, note that there is no header! specify header False
features <- read.table("./UCI HAR Dataset/features.txt", row.names = 1, header = F)
#find all the index for measurements of mean/std deviation
indexMeanStd <- grep("mean\\(\\)|std\\(\\)", features[,1])

#subset your data by indexes. 
xmerge_MeanStd <- xmerge[, indexMeanStd]

#
#
#
## Step 3. Appropriately labels the data set with descriptive variable names

#note that the data file do not have headers to begin with. We use the 'features' file as a reference for what those headers might be. Here we will rename the headers.
names(xmerge_MeanStd) <- features[indexMeanStd,]

#we will fix some abbreviations to make it more clear. headers in r do not accept '-'
names(xmerge_MeanStd) <- gsub("^t","Time_", names(xmerge_MeanStd))
names(xmerge_MeanStd) <- gsub("^f","Frequency_", names(xmerge_MeanStd))
names(xmerge_MeanStd) <- gsub("BodyBody","Body", names(xmerge_MeanStd))
names(xmerge_MeanStd) <- gsub("-","_", names(xmerge_MeanStd))
names(xmerge_MeanStd) <- gsub("\\(\\)","", names(xmerge_MeanStd))

#
#
#
#
## Step 4. Uses descriptive activity names to name the activities in the data set

#put header on the data variables
names(ymerge) <- "Activity"
names(submerge) <- "Subject"

#load activity_labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F)
names(activity_labels) <- c("ID","Activity")

#replace each number by the activity label
for(i in 1:nrow(activity_labels)){
  ymerge[,1] <- gsub(activity_labels$ID[i], activity_labels$Activity[i], ymerge[,1])
}

compile <- cbind(submerge, ymerge, xmerge_MeanStd)

#
#
#
## Step 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

#factors to split by
subjectActivity <- paste(submerge[,1], ymerge[,1])
#new dataframe with 1 row for each factor. columns are the same
compileMeans <- data.frame(
  matrix(ncol = ncol(compile), 
         nrow = length(levels(factor(subjectActivity))) 
         ))
#the rows are now reduced to each unique level of 'Subject' and 'Activity'. We compute the average of each level in which is stored in each row of the new dataframe.
for(i in 3:ncol(compile)){
  compileMeans[,i] <- sapply(split(compile[,i], subjectActivity), mean)
}

#reinsert levels of 'Subject' and 'Activity' back into the first and second column
compileMeans[,c(1:2)] <- do.call(rbind, strsplit(levels(factor(subjectActivity)), " "))
#reinsert the header with the old.
names(compileMeans) <- names(compile)

#
#
#
## Clean

#reorder
compileMeans <- compileMeans[order(as.numeric(compileMeans$Subject)),]
#write
write.table(compileMeans, "processed_data.txt", row.names = F, sep = "\t")
