# This script assumes an unzipped version of the data set
# is already located in the working directory
#
# The resulting data frame (steps 1-4) is named df
# The data frame resulting from step 5 is called df_means

### Making df (steps 1-4, though not done exactly in that order) ###

# Read feature label list
features <- read.table("UCI HAR Dataset/features.txt")[,2]

# Read activity label list (as characters)
activities <- as.character(read.table("UCI HAR Dataset/activity_labels.txt")[,2])

# Make function that turns activity code into activity text
act_text <- function(code) {activities[code]}

# Read test subjects
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Read test activities and turn them into text
act_test <- sapply(read.table("UCI HAR Dataset/test/y_test.txt"), act_text)

# Read test results
res_test <- read.table("UCI HAR Dataset/test/X_test.txt")

# Create data frame combining test subject, activity and result
test_frame <- cbind(sub_test, act_test, res_test)


# Read training subjects
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Read test activities and turn them into text
act_train <- sapply(read.table("UCI HAR Dataset/train/y_train.txt"), act_text)

# Read test results
res_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# Create data frame combining train subject, activity and result
train_frame <- cbind(sub_train, act_train, res_train)


# Construct data frame by joining test and training data.
# Add column names and order by subject, then activity (alphabetically)
df <- rbind(test_frame, train_frame)
colnames(df) <- c("subject", "activity", as.character(features))
df <- df[order(df$subject, df$activity),]


# Define function that tells if a string is in a feature description
in_feature <- function(feature, string) {
  length(grep(string, feature)) > 0
}

# Use in_feature to make a function that checks for "mean" and "std"
mean_or_std <- function(feature) {
  in_feature(feature, "mean") | in_feature(feature, "std")
}

# Make logical vector of features that contains "mean" or "std"
logic_feat <- sapply(features, mean_or_std)

# Pick out the features that we're interested in from the dataset
# Add two TRUEs at the start, since we want to retain subject and activity
df <- df[,c(TRUE, TRUE, logic_feat)]


### Making df_mean (step 5) ###

# Since there's 30 subjects, each with 6 activites, the subject
# column should have the number 1-30, each repeated 6 times
sub_col <- rep(1:30, each = 6)

# The activity column, on the other hand, should be the 6 activities
# repeated 30 times
act_col <- rep(activities, 30)

# Make function to extract data for given subject and activity (string),
# Leaving out the subject and activity itself
extract_data <- function(sub, act) {
  df[(df$subject == sub & df$activity == act), 3:81]
}

# Turn into vector of means
means_vec <- function(sub, act) {
  as.vector(colMeans(extract_data(sub, act)))
}

# To construct the main body of df_means, start with an empty data frame
means_body <- data.frame(NULL)

# Add to means_body by looping over subject and activity
for (sub in 1:30) {
  for (act in activities) {
    means_body <- rbind(means_body, means_vec(sub, act))
  }
}

# Finally create df_means and add column names (same as df)
df_means <- cbind(sub_col, act_col, means_body)
colnames(df_means) <- colnames(df)