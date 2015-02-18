# Codebook

The tidy data consists of two R data frames: df and df_means

## Columns of the data frames
Each data frame has 81 columns:
* Column 1 contains the subject number, varying between 1-30, each corresponding to a specific test/training person.
* Column 2 contains the activity performed expressed as a text. There's 6 different activities.
* Columns 3-81 contains various means and standard deviations corresponding to the relevant test/training run. The column name describes the exact nature of the measurement. All are normalized and bounded within [-1,1].

## Rows of the first data frame: df
Each row in this data frame corresponds to a specific subject performing one specific test or training activity.
Thus there may be several instances of the same subject/activity combination.
The data frame contains a total of 10299 rows.

## Rows of the second data frame: df_means
Each row in this data frame contains the mean of all the test/training results for a specific subject/activity combination.
Therefore, there are a total of 30 (number of subjects) times 6 (number of activities) rows, equalling 180.