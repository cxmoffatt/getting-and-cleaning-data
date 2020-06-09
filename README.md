The run_analysis.R script transforms data from the UCI HAR Dataset into a txt file containing a tidy data output.

It performs the following steps:

1. Load dplyr library, which will be used throughout the script.
2. Download zip file of UCI HAR Dataset
3. Read the test, training and label data
4. Merge the test and training data
5. Apply activity, subject and feature labels to the data
6. Consolidate data to only include mean and standard deviation data
7. Add descriptive labels and variable names to the data
8. Summarize data by taking the average of each measurement for each subject and type of activity
9. Write the final summary data to the tidy_data.txt file