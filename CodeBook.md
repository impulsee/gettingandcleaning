# Description

## The script **run_analysis.R** parts

* Installs & loads necessary libs `dplyr` `reshape2` 
* downloads the data from [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
* replaces `activity` values in the dataset with descriptive activity names.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Add column SetType - description in what set observation is.
* Changes column labels to descriptive.
* Merges the training and the test sets to create one data set.
* Creates 2 datasets 
    + First dataset with 69 columns and 10299 observations
    + Second with 68 columns and 180 observations
  
## Inside run_analysis.R 

The script is parititioned into functions and have code, which executed on script load. Main functions are `CreateTidyDataSet` which creates first dataset and `CreateDataSetWithMean` which creates second. First function 
have parameter `DownloadAndExtract` with default `TRUE` - if `FALSE` function skips stage of unzip and download data.
Second have parameter `Dataset` - set with appropriately loaded data from UCI HAR Dataset (e.g. dataset from `CreateTidyDataSet` function).


# Getting and cleaning data

### Part 1 - Creating first tidy dataset
1. Downloading data from the web.
2. Loading activities from *y_test.txt* or *y_train.txt* file
3. Create new column *ID* - number of observation in file
4. Loading activities name
5. Merges activities with names by *ActivityID*
6. Loading subjects from *subject_test.txt* or *subject_train.txt* file
7. Adding subjects to activities
8. Loading features name from *features.txt* file
9. Loading observations of dataset from *x_test.txt* or *x_train.txt* file
10. Extracting from observations only columns with Mean or Std values
11. Merging dataset description from step 7 and dataset from step 10
12. Create column *SetType* - information about Set (Test / Train)
13. Perform column name renaming.
14. Delete from dataset columns *ID* and *ActivityID*
15. Steps 1-14 executed for test and train files - creating testdataset and traindataset
16. Make one dataset from two datasets, created on Step 15
17. Save dataset in *tidyfull.txt* file

### Part 2 - creating second dataset
1. Using dataset, created in Part 1 in Step 16
2. Melting data based on "SetType", "ActivityName", "SubjectID"
3. Perform casting formula to evaluate average of each variable for each activity and each subject. 
4. Save dataset from Step 3 to *tidyavg.txt* file

### Script results - variable names
First dataset have 69 columns - 3 describing *SetType* *ActivityName* *SubjectID* and 66 with variables.
Second dataset have 68 columns - all from first dataset except *SetType*

All variable column names are similar to names in original dataset and looks like this

"tBodyAcc_Mean-Z" 

"tBodyAcc_Std-X" 

"tBodyAcc_Std-Y" 

"tBodyAcc_Std-Z" 

"tGravityAcc_Mean-X" 

"tGravityAcc_Mean-Y" 


# Original Data description 

Original variables and data described in [UCI HAR Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) and on [UCI HAR Website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)