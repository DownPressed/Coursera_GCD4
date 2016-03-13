# Coursera_GCD4

Files in repo:
* CGCD4.pdf - Codebook for the analysis
* SamsungClean.txt - text file containing cleaned data from the Samsung accelerometer data
* run_analysis.R - script to obtain the SamsungClean.txt file

## How run_analysis.R works

Having downloaded the Samsung Galaxy S smartphone data this function generates summary statistics for all measured accelerometer data. All files are read into R and the values that will be used as variable names / activity labels extracted. The training and test datasets are merged into a single data frame and activity numbers replaced with descriptors as per "activity_labels.txt".
    
Measurements on the mean and standard deviation for each measurement are extracted before a new dataset is created, which subsets the data based on subject number and activity to give the mean value for each measurement from the previous data frame.
