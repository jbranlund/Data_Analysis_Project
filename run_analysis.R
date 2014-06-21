##If the data isn't already loaded, then create a folder and download the zipped data into it.

URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("data")){
	dir.create("data")
	download.file(URL, destfile="./data/Dataset.zip", method="curl")
}

##List files present in the zipped file

FileNames <- unzip("data/Dataset.zip",list=TRUE)
FileNames

##Extract only the files needed - the training and test data sets

unzip("data/Dataset.zip", files=c("UCI HAR Dataset/test/X_test.txt","UCI HAR Dataset/test/y_test.txt", "UCI HAR Dataset/train/X_train.txt", "UCI HAR Dataset/train/y_train.txt", "UCI HAR Dataset/activity_labels.txt", "UCI HAR Dataset/features.txt"))

##Here, the database for the test dataset is created as a table, column headings and activities are added.

library(data.table)
DT <- read.table("UCI HAR Dataset/test/X_test.txt")
activity <- read.table("UCI HAR Dataset/test/y_test.txt")
DT2 <- data.table(DT)
names <- read.table("UCI HAR Dataset/features.txt")
names <- names[,2]
names <- as.character(names)
setnames(DT2,names)
DT2 <- cbind(activity, DT2)
setnames(DT2,"V1","Activity")

##A second database with column headings and activities is created for the training dataset.

DT <- read.table("UCI HAR Dataset/train/X_train.txt")
activity <- read.table("UCI HAR Dataset/train/y_train.txt")
DT3 <- data.table(DT)
setnames(DT3,names)
DT3 <- cbind(activity, DT3)
setnames(DT3,"V1","Activity")

##The two data tables are merged into one
DT <- rbind(DT2, DT3)
DT <- data.table(DT)

##Look through names. If names does not contain mean or std, then delete this from DT.
nameNumber <- length(names)
for (i in 1:nameNumber){
	if (grepl("mean",names[i]) == FALSE){
		if (grepl("std",names[i]) == FALSE){
			DT[, names[i]:=NULL]
			}
		}
}

##Next step, replace activity numbers with activity names. This is a bit clunky, but it works.
DT <- DT[,Activity:=as.character(Activity)]
new <- gsub("1","walking", DT[,Activity]) #this creates a string with the #1 replaced
DT[, Activity:=new] #the string is used to replace the Activity column
new <- gsub("2", "walking upstairs", DT[,Activity])
DT[, Activity:=new]
new <- gsub("3", "walking downstairs", DT[,Activity])
DT[, Activity:=new]
new <- gsub("4", "sitting", DT[,Activity])
DT[, Activity:=new]
new <- gsub("5", "standing", DT[,Activity])
DT[, Activity:=new]
new <- gsub("6", "laying", DT[,Activity])
DT[, Activity:=new]

##Save this data table as a file 
write.csv(DT, file="ExerciseData.csv")

##splits the data frame by activity
new <- split(DT, DT$Activity)

##Creates a vector containing row names
r <- c("Mean Body Acceleration X(t)", "Mean Body Acceleration Y(t)", "Mean Body Acceleration Z(t)", "Body Acceleration X(t) Standard Deviation", "Body Acceleration Y(t) Standard Deviation", "Body Acceleration Z(t) Standard Deviation",  "Mean Gravity Acceleration X(t)", "Mean Gravity Acceleration Y(t)", "Mean Gravity Acceleration Z(t)", "Gravity Acceleration X(t) Standard Deviation", "Gravity Acceleration Y(t) Standard Deviation", "Gravity Acceleration Z(t) Standard Deviation", "Mean Body Linear Acceleration X(t)", "Mean Body Linear Acceleration Y(t)", "Mean Body Linear Acceleration Z(t)", "Body Linear Acceleration X(t) Standard Deviation", "Body Linear Acceleration Y(t) Standard Deviation", "Body Linear Acceleration Z(t) Standard Deviation", "Mean Body Gyroscope Measurement X(t)", "Mean Body Gyroscope Measurement Y(t)", "Mean Body Gyroscope Measurement Z(t)", "Body Gyroscope Measurement X(t) Standard Deviation", "Body Gyro scope Measurement Y(t) Standard Deviation", "Body Gyroscope Measurement Z(t) Standard Deviation", "Mean Body Angular Velocity X(t)", "Mean Body Angular Velocity Y(t)", "Mean Body Angular Velocity Z(t)", "Body Angular Velocity X(t) Standard Deviation", "Body Angular Velocity Y(t) Standard Deviation", "Body Angular Velocity Z(t) Standard Deviation", "Mean Magnitude of Body Acceleration", "Magnitude of Body Acceleration Standard Deviation", "Mean Magnitude of Gravity Acceleration", "Magnitude of Gravity Acceleration Standard Deviation", "Magnitude of Mean Body Linear Acceleration", "Magnitude of Body Linear Acceleration Standard Deviation", "Magnitude of Mean Body Gyroscope Measurement", "Magnitude of Body scope Measurement Standard Deviation", "Magnitude of Mean Body Angular Velocity", "Magnitude of Body Angular Velocity Standard Deviation", "Mean Body Acceleration X(f)", "Mean Body Acceleration Y(f)", "Mean Body Acceleration Z(f)", "Body Acceleration X(f) Standard Deviation", "Body Acceleration Y(f) Standard Deviation", "Body Acceleration Z(f) Standard Deviation", "Mean Frequency of Body Acceleration X(f)", "Mean Frequency of Body Acceleration Y(f)", "Mean Frequency of Body Acceleration Z(f)", "Mean Body Linear Acceleration X(f)", "Mean Body Linear Acceleration Y(f)", "Mean Body Linear Acceleration Z(f)", "Body Linear Acceleration X(f) Standard Deviation", "Body Linear Acceleration Y(f) Standard Deviation", "Body Linear Acceleration Z(f) Standard Deviation", "Mean Frequency of Linear Acceleration X(f)", "Mean Frequency of Linear Acceleration Y(f)", "Mean Frequency of Linear Acceleration Z(f)", "Mean Body Gyroscope Measurement X(f)", "Mean Body Gyroscope Measurement Y(f)", "Mean Body Gyroscope Measurement Z(f)", "Body Gyroscope Measurement X(f) Standard Deviation", "Body Gyroscope Measurement Y(f) Standard Deviation", "Body Gyroscope Measurement Z(f) Standard Deviation", "Mean Frequency of Body Gyroscope Measurement X(f)", "Mean Frequency of Body Gyroscope Measurement Y(f)", "Mean Frequency of Body Gyroscope Measurement Z(f)", "Magnitude of Mean Body Accelations, frequency domain", "Magnitude of Body Acceleration, Standard Deviation, in frequency domain", "Magnitude of Mean Frequency of Body Acceleration in frequency domain", "Magnitude of Mean Body Linear Acceleration in frequency domain", "Std Magnitude of Body Linear Acceleration, Standard Deviation, in frequency domain", "Magnitude of Mean Frequency of Body Linear Acceleration in frequency domain", "Magnitude of Mean Body Gyroscope Measurement in frequency domain", "Magnitude of Body Gyroscope Measurement, Standard Deviation, in frequency domain", "Magnitude of Mean Frequency of Body Gyroscope Measurement in frequency domain", "Magnitude of Mean Body Angular Velocity in frequency domain", "Magnitude of Body Angular Velocity, Standard Deviation, in frequency domain", "Mangitude of Mean Frequency of Body Angular Velocity in frequency domain")

##Creates a data frame that will be the "tidy" data set
answer <- data.frame(row.names = r)
answer[c("Laying","Sitting","Standing", "Walking", "Walking_Downstairs", "Walking_Upstairs")] <- NA

##Calculates mean values and adds them to answer
for (i in 1:6){
	d <- new[i] # is just one of the activities
	d <- data.frame(d) #d is a data frame with stuff from just one activity
	means <- numeric()
	for (j in 2:80){
		means <- c(means,mean(d[,j]))
	}
	if (i == 1){
		answer$Laying <- c(means)
	}
	if (i == 2){
		answer$Sitting <- c(means)
	}
	if (i==3){
		answer$Standing <- c(means)
	}
	if (i == 4){
		answer$Walking <- c(means)
	}
	if (i == 5){
		answer$Walking_Downstairs <- c(means)
	}
	if (i==6){
		answer$Walking_Upstairs <- c(means)
	}
	}

##Writes data frame to a file
write.csv(answer, "MeanByActivity.txt")