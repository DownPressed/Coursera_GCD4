run_analysis <- function() {
    
    ## Having downloaded the Samsung Galaxy S smartphone data this function
    ## generates summary statistics for all measured accelerometer data
    
    
    library(plyr)
    library(reshape2)
    
    ## Read in the list of files within the overall folder
    
    setwd("./UCI HAR Dataset/")
    file_list <- list.files(,recursive = T,include.dirs = F)
    
    ## Extract the values that will be used as variable names and description of
    ## activities
    features <- read.table("features.txt")
    activities <- read.table("activity_labels.txt")
    
    ## Extract filenames to allow for easy merge
    
    fl <- strsplit(grep("train",file_list,value = T),"/")
    rm_end <- function(x) {
        x <- strsplit(tail(x,n = 1),"\\.")[1]
    }
    fl <- sapply(fl,rm_end)
    nms <- function(x) {
        x <- x[1]
    }
    fl <- sapply(fl,nms)
    rm_t <- function(x) {
        x <- sub("_train","",x)
    }
    fl <- unname(sapply(fl,rm_t))
    
    
    set_train <-
        lapply(grep("train",file_list,value = T),read.table)
    names(set_train) <- fl
    set_test <- lapply(grep("test",file_list,value = T),read.table)
    names(set_test) <- fl
    set_test <-
        data.frame(set_test); set_train <- data.frame(set_train)
    
    ## Merge the training and test datasets into a single data frame
    
    set <- rbind(set_test,set_train)
    
    names(set)[names(set) == "V1"] <- "subject"
    names(set)[names(set) == "V1.1"] <- "activity"
    a <- grep("subject|activity",names(set))
    set <- set[,c(a[1],a[2],1:(a[1] - 1),(a[1] + 1):(a[2] - 1))]
    set <- set[order(set[,1],set[,2]),]
   
    ## Replace activity numbers with descriptors as per "activity_labels.txt"
    
    for (i in 1:6) {
        set$activity[set$activity == i] <- as.character(activities$V2[i])
    }
    
    s1 <- grep("X\\.V.*",names(set))
    s1h <- s1[1]; s1t <- s1[561]
    for (i in s1h:s1t) {
        names(set)[i] <-
            sub("X\\.V.*",paste("X.",features$V2[(i - s1h + 1)],sep = ""),names(set)[i])
    }
    
    ## Extract only the measurements on the mean and standard deviation for each measurement
    
    set <- set[,grep("subject|activity|mean|std",names(set))]
    
    ## Create a new dataset which subsets the data based on subject number and
    ## activity to give the mean value for each measurement from the previous
    ## data frame (set)
    
    summary <- melt(set,id.vars = c("subject", "activity"))
    summary_clean <-
        ddply(summary, c("subject","activity","variable"),summarise,mean = mean(value))
    
    write.table(summary_clean,"../SamsungClean.txt",row.names = FALSE)
}