CodeBook.md
This code book describes the variables, the data, and any transformations or work that you performed to clean up the data.

## The obtained dataset has been randomly partitioned into two sets, 
## where 70% of the volunteers was selected for generating the training data and 30% the test data.
##=================================================================================================
### General overview of the solution:
=====================================
The files that were extracted from the zip file: getdata-projectfiles-UCI HAR Dataset.zip, with the main folder: "UCI HAR Dataset"
The following files are in "UCI HAR Dataset":

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. 
Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.  

##Note: 
=======
"UCI HAR Dataset" was set as my working directory for the run_analysis.R script.
setwd("C:/SopraStuff/Coursera/Getting & Cleaning Data/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")
The files within the sub-sub folders: Inertial Signals, were not used for this project.
=======

## Approach taken to create the script, run_analysis.R:
=======================================================
1. Merges the training and the test sets to create one data set.
The train and test sub folders contain their respective datasets.
These were then read into R and merged into a single dataset.
Steps taken:
a. Used read.table() to read X_train.txt and X_test.txt into R
XTrainData <- read.table(file.path("train", "X_train.txt"), skip=0)
XTestData <- read.table(file.path("test", "X_test.txt"), skip=0)

b. Checked some stats, check number of records and columns:
> nrow(XTrainData)
[1] 7352
> ncol(XTrainData)
[1] 561
> nrow(XTestData)
[1] 2947
> ncol(XTestData)
[1] 561

c. Used read.table() to read y_train.txt and y_test.txt into R
yTrainData <- read.table(file.path("train", "y_train.txt"), skip=0)
yTestData <- read.table(file.path("test", "y_test.txt"), skip=0)

d. Checked some stats, check number of records and columns:
> nrow(yTrainData)
[1] 7352
> ncol(yTrainData)
[1] 561
> nrow(yTestData)
[1] 2947
> ncol(yTestData)
[1] 561

e. Combine XTrainData & yTrainData by Columns:
MyTrainDataSet <- cbind(XTrainData,yTrainData)

f. check number of columns:
> ncol(MyTrainDataSet)
[1] 562

g. Combine XTestData & yTestData by Columns:
MyTestDataSet <- cbind(XTestData,yTestData)

h. check number of columns:
> ncol(MyTestDataSet)
[1] 562

i. Combine MyTrainDataSet and MyTestDataSet by rows:
MyDataSet <- rbind(MyTrainDataSet,MyTestDataSet) 

k. check number of columns:
> ncol(MyDataSet)
[1] 562

l. check number of records:
> nrow(MyDataSet)
[1] 10299

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
Notes:
a. It is my understanding that what is being requested here is a subset of data and not to calculate anything: 
b. Based on the features_info.txt file there are mean [mean()] and standard deviation [std()] measurements for each pattern:
  #These signals were used to estimate variables of the feature vector for each pattern:  
  #  '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions:
  
  #tBodyAcc-XYZ
  #tGravityAcc-XYZ
  #tBodyAccJerk-XYZ
  #tBodyGyro-XYZ
  #tBodyGyroJerk-XYZ
  #tBodyAccMag
  #tGravityAccMag
  #tBodyAccJerkMag
  #tBodyGyroMag
  #tBodyGyroJerkMag
  #fBodyAcc-XYZ
  #fBodyAccJerk-XYZ
  #fBodyGyro-XYZ
  #fBodyAccMag
  #fBodyAccJerkMag
  #fBodyGyroMag
  #fBodyGyroJerkMag

c. The variables I am extracting, based on the features.txt file, having mean() or std() in their name are therefore:
ListOfVariables <- read.table("features.txt", stringsAsFactors = FALSE)  
MyListOfVariables <- ListOfVariables[((ListOfVariables$V2 %in% grep("mean()", ListOfVariables$V2,value=TRUE ) & 
                                         ListOfVariables$V2 %in% grep("meanFreq()", ListOfVariables$V2,value=TRUE,invert=TRUE )) | 
                                        (ListOfVariables$V2 %in% grep("std()", ListOfVariables$V2,value=TRUE ))),]  
> MyListOfVariables
V1                          V2
1     1           tBodyAcc-mean()-X
2     2           tBodyAcc-mean()-Y
3     3           tBodyAcc-mean()-Z
4     4            tBodyAcc-std()-X
5     5            tBodyAcc-std()-Y
6     6            tBodyAcc-std()-Z
41   41        tGravityAcc-mean()-X
42   42        tGravityAcc-mean()-Y
43   43        tGravityAcc-mean()-Z
44   44         tGravityAcc-std()-X
45   45         tGravityAcc-std()-Y
46   46         tGravityAcc-std()-Z
81   81       tBodyAccJerk-mean()-X
82   82       tBodyAccJerk-mean()-Y
83   83       tBodyAccJerk-mean()-Z
84   84        tBodyAccJerk-std()-X
85   85        tBodyAccJerk-std()-Y
86   86        tBodyAccJerk-std()-Z
121 121          tBodyGyro-mean()-X
122 122          tBodyGyro-mean()-Y
123 123          tBodyGyro-mean()-Z
124 124           tBodyGyro-std()-X
125 125           tBodyGyro-std()-Y
126 126           tBodyGyro-std()-Z
161 161      tBodyGyroJerk-mean()-X
162 162      tBodyGyroJerk-mean()-Y
163 163      tBodyGyroJerk-mean()-Z
164 164       tBodyGyroJerk-std()-X
165 165       tBodyGyroJerk-std()-Y
166 166       tBodyGyroJerk-std()-Z
201 201          tBodyAccMag-mean()
202 202           tBodyAccMag-std()
214 214       tGravityAccMag-mean()
215 215        tGravityAccMag-std()
227 227      tBodyAccJerkMag-mean()
228 228       tBodyAccJerkMag-std()
240 240         tBodyGyroMag-mean()
241 241          tBodyGyroMag-std()
253 253     tBodyGyroJerkMag-mean()
254 254      tBodyGyroJerkMag-std()
266 266           fBodyAcc-mean()-X
267 267           fBodyAcc-mean()-Y
268 268           fBodyAcc-mean()-Z
269 269            fBodyAcc-std()-X
270 270            fBodyAcc-std()-Y
271 271            fBodyAcc-std()-Z
345 345       fBodyAccJerk-mean()-X
346 346       fBodyAccJerk-mean()-Y
347 347       fBodyAccJerk-mean()-Z
348 348        fBodyAccJerk-std()-X
349 349        fBodyAccJerk-std()-Y
350 350        fBodyAccJerk-std()-Z
424 424          fBodyGyro-mean()-X
425 425          fBodyGyro-mean()-Y
426 426          fBodyGyro-mean()-Z
427 427           fBodyGyro-std()-X
428 428           fBodyGyro-std()-Y
429 429           fBodyGyro-std()-Z
503 503          fBodyAccMag-mean()
504 504           fBodyAccMag-std()
516 516  fBodyBodyAccJerkMag-mean()
517 517   fBodyBodyAccJerkMag-std()
529 529     fBodyBodyGyroMag-mean()
530 530      fBodyBodyGyroMag-std()
542 542 fBodyBodyGyroJerkMag-mean()
543 543  fBodyBodyGyroJerkMag-std()

d. Extract only above columns + Activities:
MyExtract <- MyDataSet[,c(MyListOfVariables$V1,562)]

4. Appropriately labels the data set with descriptive variable names. 
a. Add column names, I decided to call the column with the values of activities, "Activities":
colnames(MyExtract) <- c(MyListOfVariables$V2,"Activities")

3. Uses descriptive activity names to name the activities in the data set
Notes:
a. I decided to add a column, called "Activity", to provide the names of the activities
ListOfActivities <- read.table("activity_labels.txt", stringsAsFactors = FALSE) 
colnames(ListOfActivities) <- c("Activities", "Activity")

> ListOfActivities
Activities           Activity
1          1            WALKING
2          2   WALKING_UPSTAIRS
3          3 WALKING_DOWNSTAIRS
4          4            SITTING
5          5           STANDING
6          6             LAYING

b. I decided to use sql to join ListOfActivities and MyExtract on column: Activities

library(sqldf)
c. Add ActivityDesc to MyExtract
MyExtractFinal = sqldf("SELECT A.*, B.Activity FROM MyExtract A JOIN ListOfActivities B USING (Activities)")

d. check rows and columns:
> nrow(MyExtractFinal)
[1] 10299
> ncol(MyExtractFinal)
[1] 68 

5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
a. Read into R and Combine subject data for X and y:
SubjectTrainData <- read.table(file.path("train", "subject_train.txt"), skip=0)
SubjectTestData <- read.table(file.path("test", "subject_test.txt"), skip=0)

b. Combine SubjectTrainData and SubjectTestData by rows:
MySubjectDataSet <- rbind(SubjectTrainData,SubjectTestData) 

c. check number of records
> nrow(MySubjectDataSet)
[1] 10299

d. Add column name:
colnames(MySubjectDataSet) <- c("Subject")

e. Using the MyExtractFinal dataset, from points 1-4 as a base, I will now add the Subject column:
MyTidyData <- cbind(MyExtractFinal,MySubjectDataSet)

f. check number of columns:
> ncol(MyTidyData)
[1] 69

g. Get column names:
> colnames(MyTidyData)
[1] "tBodyAcc_mean___X"           "tBodyAcc_mean___Y"           "tBodyAcc_mean___Z"           "tBodyAcc_std___X"           
[5] "tBodyAcc_std___Y"            "tBodyAcc_std___Z"            "tGravityAcc_mean___X"        "tGravityAcc_mean___Y"       
[9] "tGravityAcc_mean___Z"        "tGravityAcc_std___X"         "tGravityAcc_std___Y"         "tGravityAcc_std___Z"        
[13] "tBodyAccJerk_mean___X"       "tBodyAccJerk_mean___Y"       "tBodyAccJerk_mean___Z"       "tBodyAccJerk_std___X"       
[17] "tBodyAccJerk_std___Y"        "tBodyAccJerk_std___Z"        "tBodyGyro_mean___X"          "tBodyGyro_mean___Y"         
[21] "tBodyGyro_mean___Z"          "tBodyGyro_std___X"           "tBodyGyro_std___Y"           "tBodyGyro_std___Z"          
[25] "tBodyGyroJerk_mean___X"      "tBodyGyroJerk_mean___Y"      "tBodyGyroJerk_mean___Z"      "tBodyGyroJerk_std___X"      
[29] "tBodyGyroJerk_std___Y"       "tBodyGyroJerk_std___Z"       "tBodyAccMag_mean__"          "tBodyAccMag_std__"          
[33] "tGravityAccMag_mean__"       "tGravityAccMag_std__"        "tBodyAccJerkMag_mean__"      "tBodyAccJerkMag_std__"      
[37] "tBodyGyroMag_mean__"         "tBodyGyroMag_std__"          "tBodyGyroJerkMag_mean__"     "tBodyGyroJerkMag_std__"     
[41] "fBodyAcc_mean___X"           "fBodyAcc_mean___Y"           "fBodyAcc_mean___Z"           "fBodyAcc_std___X"           
[45] "fBodyAcc_std___Y"            "fBodyAcc_std___Z"            "fBodyAccJerk_mean___X"       "fBodyAccJerk_mean___Y"      
[49] "fBodyAccJerk_mean___Z"       "fBodyAccJerk_std___X"        "fBodyAccJerk_std___Y"        "fBodyAccJerk_std___Z"       
[53] "fBodyGyro_mean___X"          "fBodyGyro_mean___Y"          "fBodyGyro_mean___Z"          "fBodyGyro_std___X"          
[57] "fBodyGyro_std___Y"           "fBodyGyro_std___Z"           "fBodyAccMag_mean__"          "fBodyAccMag_std__"          
[61] "fBodyBodyAccJerkMag_mean__"  "fBodyBodyAccJerkMag_std__"   "fBodyBodyGyroMag_mean__"     "fBodyBodyGyroMag_std__"     
[65] "fBodyBodyGyroJerkMag_mean__" "fBodyBodyGyroJerkMag_std__"  "Activities"                  "Activity"                   
[69] "Subject"

h. I decided to create the tidy data set with the average of each variable for each activity and each subject as follows:
i. Assuming we are expected to have an output something like:
  
Activity1,Subject1,<Average of other columns>
Activity1,Subject2,<Average of other columns>
  .....
Activity2,Subject1,<Average of other columns>
  .....
.....
Activity6,Subject30,<Average of other columns>

j. I decided to use sql and Round results to 8 decimal places and change the column names to make them more readable:
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

k. Check records, there should be 180 rows (30 subjects x 6 activities):  
> nrow(MyFinalTidyDataSet)
[1] 180

l. The aggregate function gives similar results but with Group.1 and Group.2 column headings instead of Activity, Subject. Also the column: Activity = NA:
aggdata <-aggregate(MyTidyData, by=list(MyTidyData$Activity, MyTidyData$Subject), FUN=mean, na.rm=TRUE)

Question to upload tidy data set:
a. Please upload the tidy data set created in step 5 of the instructions. 
b. Please upload your data set as a txt file created with write.table() using row.name=FALSE
Solution:
a. I decided to use the sqldf dataset because it's using better column headings and no NAs.
b. I used the pipe,|, delimiter and quotes around character values and proper column names:
write.table(MyFinalTidyDataSet, file = "MyFinalTidyDataSet.txt", append = FALSE, quote = TRUE, sep = "|",
            eol = "\n", na = "NA", dec = ".", row.names = FALSE,
            col.names = TRUE, qmethod = c("escape", "double"),
            fileEncoding = "")

			
> colnames(MyFinalTidyDataSet)
 [1] "Activity"                  "Subject"                   "tBodyAcc_mean"             "tBodyAcc_mean_Y"           "tBodyAcc_mean_Z"          
 [6] "tBodyAcc_std_X"            "tBodyAcc_std_Y"            "tBodyAcc_std_Z"            "tGravityAcc_mean_X"        "tGravityAcc_mean_Y"       
[11] "tGravityAcc_mean_Z"        "tGravityAcc_std_X"         "tGravityAcc_std_Y"         "tGravityAcc_std_Z"         "tBodyAccJerk_mean_X"      
[16] "tBodyAccJerk_mean_Y"       "tBodyAccJerk_mean_Z"       "tBodyAccJerk_std_X"        "tBodyAccJerk_std_Y"        "tBodyAccJerk_std_Z"       
[21] "tBodyGyro_mean_X"          "tBodyGyro_mean_Y"          "tBodyGyro_mean_Z"          "tBodyGyro_std_X"           "tBodyGyro_std_Y"          
[26] "tBodyGyro_std_Z"           "tBodyGyroJerk_mean_X"      "tBodyGyroJerk_mean_Y"      "tBodyGyroJerk_mean_Z"      "tBodyGyroJerk_std_X"      
[31] "tBodyGyroJerk_std_Y"       "tBodyGyroJerk_std_Z"       "tBodyAccMag_mean"          "tBodyAccMag_std"           "tGravityAccMag_mean"      
[36] "tGravityAccMag_std"        "tBodyAccJerkMag_mean"      "tBodyAccJerkMag_std"       "tBodyGyroMag_mean"         "tBodyGyroMag_std"         
[41] "tBodyGyroJerkMag_mean"     "tBodyGyroJerkMag_std"      "fBodyAcc_mean_X"           "fBodyAcc_mean_Y"           "fBodyAcc_mean_Z"          
[46] "fBodyAcc_std_X"            "fBodyAcc_std_Y"            "fBodyAcc_std_Z"            "fBodyAccJerk_mean_X"       "fBodyAccJerk_mean_Y"      
[51] "fBodyAccJerk_mean_Z"       "fBodyAccJerk_std_X"        "fBodyAccJerk_std_Y"        "fBodyAccJerk_std_Z"        "fBodyGyro_mean_X"         
[56] "fBodyGyro_mean_Y"          "fBodyGyro_mean_Z"          "fBodyGyro_std_X"           "fBodyGyro_std_Y"           "fBodyGyro_std_Z"          
[61] "fBodyAccMag_mean"          "fBodyAccMag_std"           "fBodyBodyAccJerkMag_mean"  "fBodyBodyAccJerkMag_std"   "fBodyBodyGyroMag_mean"    
[66] "fBodyBodyGyroMag_std"      "fBodyBodyGyroJerkMag_mean" "fBodyBodyGyroJerkMag_std" 
> 
			
The these steps have been copied from the R script, run_analysis.R
Also, I have added another document, CodeBook.pdf, that clearly maps the source attributes and measures to the target, MyFinalTidyDataSet.

To Import this data set into R use the following statement:
		   
MyFinalTidyDataSet <- read.table(file = "MyFinalTidyDataSet.txt", header = TRUE, sep = "|", quote = "\"'",
                                 dec = ".", numerals = c("allow.loss", "warn.loss", "no.loss"), skip = 0, check.names = TRUE)		   
