##Getting & Cleaning Data Course Project 

Here a brief description of the script uploaded.

Following the assignment request there are 5 step (+ 1 pre-processing step):



**0. Pre-processing phase** 

In this phase the script will just load the requested libraries.

My original version provided also the download and unzipping phases of the data. 


**1. Merges the training and the test sets to create one data set**

a) The script uses the read.table() function to load the data 

b) and rbind() to merge the two datasets (same variables).

**2. Extracts only the measurements on the mean and standard deviation for each measurement**

a) Read.table() to load the features list.

b) grep() to get the position of the variables requested (searching for the string "mean()","std()","mean","std") in the dataset of the 1st step.

c) at the end just the relevant variables are selected using the columns number provided by grep().


 
**3. Uses descriptive activity names to name the activities in the data set**

a) read.table() to load the labels table and the activities identifiers of the training and test dataset.

b) rbind() to create an unique dataframe with the activities identifiers.

c) To keep the original order (merge will change it) the script adds a column with the observation number (row number).

d) merge() merges the labels and activities database to get the description for each observation.

e) order() to get back the real observations order using the column created in step c).

f)  at the end cbind() to add the descriptive activity name to the dataset.




**4. Appropriately labels the data set with descriptive variable names**

After a character conversion of the variables/features list (step 2) colnames() updates the names of the variables.


**5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject**

a) read.table() to load the subject identifiers of the training and test dataset.

b) rbind() to create an unique dataframe with the subject identifiers.

c) the subject column is added to the dataset.

d) the functions of the dplyr package are then used to group and summarize the data as requested.

e) write.table() creates a .Summary_test5.txt file with the summarized dataset.


**To load the Summary_test5.txt in R:**

```data <- read.table(file_path, header = TRUE)

   View(data)```