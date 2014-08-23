## You should create one R script called run_analysis.R that does the following. 
## The obtained dataset has been randomly partitioned into two sets, 
## where 70% of the volunteers was selected for generating the training data and 30% the test data.

setwd("C:/SopraStuff/Coursera/Getting & Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
## 1. Merges the training and the test sets to create one data set.
## 'train/X_train.txt': Training set.
## 'test/X_test.txt': Test set.
## Read data into R:
## X
XTrainData <- read.table(file.path("train", "X_train.txt"), skip=0)
XTestData <- read.table(file.path("test", "X_test.txt"), skip=0)

## get some stats, check number of records:
> nrow(XTrainData)
[1] 7352
> ncol(XTrainData)
[1] 561

> nrow(XTestData)
[1] 2947
> ncol(XTestData)
[1] 561

## y
yTrainData <- read.table(file.path("train", "y_train.txt"), skip=0)
yTestData <- read.table(file.path("test", "y_test.txt"), skip=0)

## get some stats, check number of records:
nrow(yTrainData)
ncol(yTrainData)
nrow(yTestData)
ncol(yTestData)

## Combine XTrainData & yTrainData by Columns:
MyTrainDataSet <- cbind(XTrainData,yTrainData)
## check number of columns:
ncol(MyTrainDataSet)

## Combine XTestData & yTestData by Columns:
MyTestDataSet <- cbind(XTestData,yTestData)
## check number of columns:
ncol(MyTestDataSet)

## Combine MyTrainDataSet and MyTestDataSet by rows:
MyDataSet <- rbind(MyTrainDataSet,MyTestDataSet) 
## get stats, check number of columns::
ncol(MyDataSet)

## check number of records:
> nrow(MyDataSet)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## It is my understanding that what is being requested here is a subset of data and not to calculate anything: 
## Based on the features_info.txt file there are mean [mean()] and standard deviation [std()] measurements for each pattern:
##The variables I am extracting, based on the features.txt file, having mean() or std() in their name are therefore:
ListOfVariables <- read.table("features.txt", stringsAsFactors = FALSE)  
MyListOfVariables <- ListOfVariables[((ListOfVariables$V2 %in% grep("mean()", ListOfVariables$V2,value=TRUE ) & 
                                         ListOfVariables$V2 %in% grep("meanFreq()", ListOfVariables$V2,value=TRUE,invert=TRUE )) | 
                                        (ListOfVariables$V2 %in% grep("std()", ListOfVariables$V2,value=TRUE ))),]  

## Check column names:										
MyListOfVariables

## Extract only above columns + Activities:
MyExtract <- MyDataSet[,c(MyListOfVariables$V1,562)]

## 4. Appropriately labels the data set with descriptive variable names. 
## Add columne names:
colnames(MyExtract) <- c(MyListOfVariables$V2,"Activities")

## 3. Uses descriptive activity names to name the activities in the data set
## I decided to add a column, called ActivityDesc, to provide the names of the activities
ListOfActivities <- read.table("activity_labels.txt", stringsAsFactors = FALSE) 
colnames(ListOfActivities) <- c("Activities", "Activity")

## Check ListOfActivities
ListOfActivities

## Use sql to join ListOfActivities and MyExtract on column: Activities
library(sqldf)

## Add ActivityDesc to MyExtract
MyExtractFinal = sqldf("SELECT A.*, B.Activity FROM MyExtract A JOIN ListOfActivities B USING (Activities)")
## check rows and columns:
nrow(MyExtractFinal)
ncol(MyExtractFinal)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
## Read into R and Combine subject data for X and y:
SubjectTrainData <- read.table(file.path("train", "subject_train.txt"), skip=0)
SubjectTestData <- read.table(file.path("test", "subject_test.txt"), skip=0)
## Combine SubjectTrainData and SubjectTestData by rows:
MySubjectDataSet <- rbind(SubjectTrainData,SubjectTestData) 

## check number of records
nrow(MySubjectDataSet)

## Add column name:
colnames(MySubjectDataSet) <- c("Subject")
## Using the MyExtractFinal dataset as a base, I will now add the Subject column:
MyTidyData <- cbind(MyExtractFinal,MySubjectDataSet)

## check number of columns:
ncol(MyTidyData)

## Get column names:
colnames(MyTidyData)
## tidy data set with the average of each variable for each activity and each subject:
## Round results to 8 decimal places:
MyFinalTidyDataSet = sqldf("SELECT Activity, Subject, 
round(avg(tBodyAcc_mean___X),8)  tBodyAcc_mean, round(avg(tBodyAcc_mean___Y),8) tBodyAcc_mean_Y, round(avg(tBodyAcc_mean___Z),8) tBodyAcc_mean_Z, round(avg(tBodyAcc_std___X),8) tBodyAcc_std_X,           
round(avg(tBodyAcc_std___Y),8) tBodyAcc_std_Y, round(avg(tBodyAcc_std___Z),8) tBodyAcc_std_Z, round(avg(tGravityAcc_mean___X),8) tGravityAcc_mean_X, round(avg(tGravityAcc_mean___Y),8) tGravityAcc_mean_Y,       
round(avg(tGravityAcc_mean___Z),8) tGravityAcc_mean_Z, round(avg(tGravityAcc_std___X),8) tGravityAcc_std_X, round(avg(tGravityAcc_std___Y),8) tGravityAcc_std_Y, round(avg(tGravityAcc_std___Z),8) tGravityAcc_std_Z,        
round(avg(tBodyAccJerk_mean___X),8) tBodyAccJerk_mean_X, round(avg(tBodyAccJerk_mean___Y),8) tBodyAccJerk_mean_Y, round(avg(tBodyAccJerk_mean___Z),8) tBodyAccJerk_mean_Z, round(avg(tBodyAccJerk_std___X),8) tBodyAccJerk_std_X,       
round(avg(tBodyAccJerk_std___Y),8) tBodyAccJerk_std_Y, round(avg(tBodyAccJerk_std___Z),8) tBodyAccJerk_std_Z, round(avg(tBodyGyro_mean___X),8) tBodyGyro_mean_X, round(avg(tBodyGyro_mean___Y),8) tBodyGyro_mean_Y,         
round(avg(tBodyGyro_mean___Z),8) tBodyGyro_mean_Z, round(avg(tBodyGyro_std___X),8) tBodyGyro_std_X, round(avg(tBodyGyro_std___Y),8) tBodyGyro_std_Y, round(avg(tBodyGyro_std___Z),8) tBodyGyro_std_Z,          
round(avg(tBodyGyroJerk_mean___X),8) tBodyGyroJerk_mean_X, round(avg(tBodyGyroJerk_mean___Y),8) tBodyGyroJerk_mean_Y, round(avg(tBodyGyroJerk_mean___Z),8) tBodyGyroJerk_mean_Z, round(avg(tBodyGyroJerk_std___X),8) tBodyGyroJerk_std_X,      
round(avg(tBodyGyroJerk_std___Y),8) tBodyGyroJerk_std_Y, round(avg(tBodyGyroJerk_std___Z),8) tBodyGyroJerk_std_Z, round(avg(tBodyAccMag_mean__),8) tBodyAccMag_mean, round(avg(tBodyAccMag_std__),8) tBodyAccMag_std,          
round(avg(tGravityAccMag_mean__),8) tGravityAccMag_mean, round(avg(tGravityAccMag_std__),8) tGravityAccMag_std, round(avg(tBodyAccJerkMag_mean__),8) tBodyAccJerkMag_mean, round(avg(tBodyAccJerkMag_std__),8) tBodyAccJerkMag_std,      
round(avg(tBodyGyroMag_mean__),8) tBodyGyroMag_mean, round(avg(tBodyGyroMag_std__),8) tBodyGyroMag_std, round(avg(tBodyGyroJerkMag_mean__),8) tBodyGyroJerkMag_mean, round(avg(tBodyGyroJerkMag_std__),8) tBodyGyroJerkMag_std,     
round(avg(fBodyAcc_mean___X),8) fBodyAcc_mean_X, round(avg(fBodyAcc_mean___Y),8) fBodyAcc_mean_Y, round(avg(fBodyAcc_mean___Z),8) fBodyAcc_mean_Z, round(avg(fBodyAcc_std___X),8) fBodyAcc_std_X,           
round(avg(fBodyAcc_std___Y),8) fBodyAcc_std_Y, round(avg(fBodyAcc_std___Z),8) fBodyAcc_std_Z, round(avg(fBodyAccJerk_mean___X),8) fBodyAccJerk_mean_X, round(avg(fBodyAccJerk_mean___Y),8) fBodyAccJerk_mean_Y,      
round(avg(fBodyAccJerk_mean___Z),8) fBodyAccJerk_mean_Z, round(avg(fBodyAccJerk_std___X),8) fBodyAccJerk_std_X, round(avg(fBodyAccJerk_std___Y),8) fBodyAccJerk_std_Y, round(avg(fBodyAccJerk_std___Z),8) fBodyAccJerk_std_Z,       
round(avg(fBodyGyro_mean___X),8) fBodyGyro_mean_X, round(avg(fBodyGyro_mean___Y),8) fBodyGyro_mean_Y, round(avg(fBodyGyro_mean___Z),8) fBodyGyro_mean_Z, round(avg(fBodyGyro_std___X),8) fBodyGyro_std_X,          
round(avg(fBodyGyro_std___Y),8) fBodyGyro_std_Y, round(avg(fBodyGyro_std___Z),8) fBodyGyro_std_Z, round(avg(fBodyAccMag_mean__),8) fBodyAccMag_mean, round(avg(fBodyAccMag_std__),8) fBodyAccMag_std,          
round(avg(fBodyBodyAccJerkMag_mean__),8) fBodyBodyAccJerkMag_mean, round(avg(fBodyBodyAccJerkMag_std__),8) fBodyBodyAccJerkMag_std, round(avg(fBodyBodyGyroMag_mean__),8) fBodyBodyGyroMag_mean, round(avg(fBodyBodyGyroMag_std__),8) fBodyBodyGyroMag_std,     
round(avg(fBodyBodyGyroJerkMag_mean__),8) fBodyBodyGyroJerkMag_mean, round(avg(fBodyBodyGyroJerkMag_std__),8) fBodyBodyGyroJerkMag_std
FROM MyTidyData
GROUP BY Activity, Subject
ORDER BY Activity, Subject")     

##Check records, there should be 180 rows (30 subjects and 6 activities):  
nrow(MyFinalTidyDataSet)

#The aggregate function gives similar results but with Group.1 Group.2 column headings instead of Activity, Subject. Also the column: Activity = NA:
aggdata <-aggregate(MyTidyData, by=list(MyTidyData$Activity, MyTidyData$Subject), FUN=mean, na.rm=TRUE)

## Please upload the tidy data set created in step 5 of the instructions. 
## Please upload your data set as a txt file created with write.table() using row.name=FALSE
## I decided to use the sqldf dataset because it's using better column headings and no NAs.
write.table(MyFinalTidyDataSet, file = "MyFinalTidyDataSet.txt", append = FALSE, quote = TRUE, sep = "|",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")
