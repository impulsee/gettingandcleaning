# Download & install packages
if(!require("dplyr")){
    install.packages("dplyr")
}
library(dplyr)
if(!require("reshape2")){
    install.packages("reshape2")
}
library(reshape2)
# This function downloads file from corresponding URL
downloadData<-function(url, destfile){    
    if(!file.exists(destfile)){
        ## first try normal method, if no - wget
        tryCatch(download.file(url, destfile=destfile) , error = function(e) e )
        e<-download.file(url, destfile=destfile, method = "wget")
    }
}

## This function tries to extract data from downloaded data
extractDownloadedData<-function(srcfile){
    if (file.exists(srcfile)){
        unzip(srcfile)
    }
    else{
        warning("No file to unzip! Use downloadData first");
    }
    
}
#This function download and extract data for this course project
DownloadExtractData<-function(){
    url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    dstfile<-"getdata-projectfiles-UCI HAR Dataset.zip"
    downloadData(url,dstfile)
    extractDownloadedData(dstfile)
}

# Loads dataset from specified data type from UCI HAR Dataset. 
# Because loads from test and train dataset pretty similar except paths, so
# I create function to load one of this dataset.
LoadDataset<-function(type = "test"){
    # Creating paths to loading files
    ypath<- paste0("UCI HAR Dataset/",type,"/y_",type,".txt")
    activitylabelspath<-"UCI HAR Dataset/activity_labels.txt"
    subjectpath<- paste0("UCI HAR Dataset/",type,"/subject_",type,".txt")
    featurespath<-"UCI HAR Dataset/features.txt"
    xpath<-paste0("UCI HAR Dataset/",type,"/x_",type,".txt")
    
    # First - loading Activities from y_type file
    colactivitylabeltest<-"ActivityID"
    dataset<-read.table(ypath,stringsAsFactors = FALSE,col.names = colactivitylabeltest)
    
    # Creating id - number of row, because merge can break row order
    dataset$id  <- 1:nrow(dataset)
    
    # Loading Activities Name
    colactivitylabelname<-c("ActivityID","ActivityName")
    activitylabelsName<-read.table(activitylabelspath,stringsAsFactors = FALSE,col.names = colactivitylabelname)
    
    # Merge dataset activities with its name
    dataset<-merge(dataset,activitylabelsName,by.x = "ActivityID",by.y = "ActivityID")
    
    # Load subject ID from file
    colsubjectid<-"SubjectID"
    subjectid<-read.table(subjectpath,stringsAsFactors = FALSE,col.names = colsubjectid)
    
    # Creating id - number of row, because merge can break row order
    subjectid$id  <- 1:nrow(subjectid)
    
    #Merge subject to dataset
    dataset<-merge(dataset,subjectid,by.x="id",by.y="id")
    
    #Loading features name 
    colfeatures<-c("ColumnID","FeatureName")
    features<-read.table(featurespath,stringsAsFactors = FALSE,col.names = colfeatures)
    
    #Loading data of our dataset
    datasetdata<-read.table(xpath,stringsAsFactors = FALSE,col.names = features$FeatureName,check.names = FALSE)
    
    # Creating id - number of row, because merge can break row order
    datasetdata$id  <- 1:nrow(datasetdata)
    
    # Extracting from datasetdata only mean and std columns
    datasetdata<-(datasetdata[,grepl("mean\\(\\)|std\\(\\)|^id$",tolower(colnames(datasetdata)))])
    
    #Merge Data and description of data
    dataset<-merge(dataset,datasetdata,by.x="id",by.y="id")
    
    # Creating column - in what set (Test / Train) is this value
    dataset<-cbind.data.frame(SetType=type,dataset,stringsAsFactors = FALSE)
    
    #Change variable names
    dataset_labels <- colnames(dataset)
    dataset_labels <- gsub("\\-[Ss]td\\(\\)","_Std", dataset_labels)
    dataset_labels <- gsub("\\-[Mm]ean\\(\\)","_Mean", dataset_labels)
    colnames(dataset) <- dataset_labels
    
    #Return dataset without 2 columns - ID (row number) and ActivityID
    dataset[,-c(2,3)]
}
#This function creates TidyDataset and retuns it
# DownloadAndExtract - Is necessary to load DataSet from web if false, assumes that UCI HAR Dataset already loaded
CreateTidyDataSet<-function(DownloadAndExtract = TRUE){
    if (DownloadAndExtract == TRUE){
        DownloadExtractData()
    }
    
    #Loading test dataset
    datasettest<-LoadDataset()
    
    #Loading train dataset
    datasettrain<-LoadDataset(type = "train")
    
    #Creating one tidy Dataset
    tidydataset<-rbind(datasettest,datasettrain)
    tidydataset
}
#This function creates TidyDataset with means and retuns it
CreateDataSetWithMean<-function(Dataset = TidyData){
    
    id_vars<- c("SetType", "ActivityName", "SubjectID")
    measure_vars<- setdiff(colnames(TidyData), id_vars)
    #Melt Dataset to perform mean
    melted_data <- melt(TidyData, id=id_vars, measure.vars=measure_vars)
    
    # Perform mean 
    tidydatasetmean<-dcast(melted_data, ActivityName + SubjectID ~ variable, mean)
    tidydatasetmean
    
}

# Load & save first dataset
tidydataset<-CreateTidyDataSet(TRUE)
fname<-"tidyfull.txt"
write.table(tidydataset, fname)

# Load & save dataset with means
fname<-"tidyavg.txt"
tidydatasetmean<-CreateDataSetWithMean(tidydataset)
write.table(tidydatasetmean, fname)
