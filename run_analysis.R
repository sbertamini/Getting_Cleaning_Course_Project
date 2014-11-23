###########################################
##  0. Preprocessing phase -> libraries  ##
###########################################

# libraries needed

library(dplyr)


########################################################################
##  1. Merges the training and the test sets to create one data set.  ##
########################################################################

test<-read.table("./UCI HAR Dataset/test/X_test.txt")
training<-read.table("./UCI HAR Dataset/train/X_train.txt")
dataset<-rbind(training,test) # merging the two datasets
rm(training,test)    # to free some memory      


##################################################################################################
##  2. Extracts only the measurements on the mean and standard deviation for each measurement.  ##
##################################################################################################

feature<-read.table("./UCI HAR Dataset/features.txt")        

# identifing the positions of the feature containing mean(), std(), mean, std. 
FeatureSel<-grep("mean\\(\\)|std\\(\\)|mean|std",feature$V2,ignore.case=TRUE)
dataset<-dataset[,FeatureSel] #keeping just the columns of interest  


##################################################################################
##  3. Uses descriptive activity names to name the activities in the data set.  ##
##################################################################################

labels<-read.table("./UCI HAR Dataset/activity_labels.txt")
test_act<-read.table("./UCI HAR Dataset/test/y_test.txt")
training_act<-read.table("./UCI HAR Dataset/train/y_train.txt")

TOTact<-rbind(training_act,test_act) #merging the two activities datasets
rm(training_act,test_act)  #to free some memory

TOTact<-cbind(OR=1:nrow(TOTact),TOTact)   #adding a column to keep the correct observation number before the merging 
TOTact<-merge(TOTact,labels,by.x=2,by.y=1) #merging label and activity database to get the description for each observation
TOTact<-TOTact[order(TOTact$OR),]  # sorting according the original order of activities before the merge
dataset<-cbind(TOTact[,3],dataset)  # adding the descriptive activity name to the dataset

#############################################################################
##  4. Appropriately labels the data set with descriptive variable names.  ## 
#############################################################################

feature[,2]<-as.character(feature[,2])   # need the conversion from factor to char before naming
colnames(dataset)<-c("Activity",feature[FeatureSel,2])  # Naming the columns


##################################################################################
##  5. From the data set in step 4, creates a second,independent tidy data set  ##
##     with the average of each variable for each activity and each subject.    ##
##################################################################################

sub_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
sub_training<-read.table("./UCI HAR Dataset/train/subject_train.txt")
TOTsub<-rbind(sub_training,sub_test) # merging the Subject identifiers

rm(sub_training,sub_test) # to free some memory

colnames(TOTsub)<-"Subject"

dataset_v2<-cbind(TOTsub,dataset) # adding the Subject column

dataset_v2<-tbl_df(dataset_v2)   # dplyr data.frame

dataset_v2<-group_by(dataset_v2,Subject,Activity) # dplyr function that allows the grouping

summary<-summarise_each(dataset_v2,funs(mean))    # summary of means for each combination of 
                                                  # Subject, Activity, Variable. 

write.table(summary,file="./Summary_step5.txt",row.names=FALSE)