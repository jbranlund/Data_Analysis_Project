##Data
###Data source
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
###The train and test datasets
The subjects in the study were divided into two groups, labeled "test" and "train" in the data list. The first task is to collect all subjects into the same dataset.
###Variable names and activity labels
The datasets available on the web contain numbers only. The variables (column labels) are found in the file called features.txt. Activities are labeled with numbers in the datasets. The numbers correspond to activities as listed in activity_labels.txt.

##The code
The run_analysis R script does the following:
*  Downloads and unzips the relevant data
*  Adds column names listed in features.txt
*  Merges the test and train datasets
*  Removes all variables that are not either a mean or standard deviation
*  Replaces the activity numbers with activity titles
*  Splits the dataset by activity
*  Calculates means for all subjects doing that activity
*  Outpits a final, "tidy" dataset giving the mean values for each activity.

##The tidy dataset
Measurements made with the accelerometer are labeled as acceleration. These measurements were made in the x, y, z directions in the time domain (labeled X(t), Y(t), etc.) and fast-fourier transforms converted the data to the frequency domain (labeled X(f), Y(f), etc.).

The data given show the average measurements of all subjects doing a certain activity. 

