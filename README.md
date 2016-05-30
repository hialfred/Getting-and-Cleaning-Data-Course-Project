# Getting-and-Cleaning-Data-Course-Project

## 0. Raw Data

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## 1. Files

#### Training files

X_train.txt

Y_train.txt

subject_train.txt

#### Test files

X_test.txt

Y_test.txt

subject_test.txt

#### features.txt

#### activity_labels.txt

## 2. Tasks

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
The R code for data prosessing is stored as run_analysis.R and processed dataset is stored as processed_data.txt.

## 3. Code Book
codebook.md describes the variables in the resulting processed_data.txt
