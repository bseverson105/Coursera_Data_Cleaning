This script will take the UCI HAR Dataset and convert it into a consolidated dataset where each feature containing a mean or standard deviation is grouped by subject and activity.

If the UCI dataset is not already present in the working directory or if the file structure of the dataset has been altered, then the script will download and unzip a new UCI HAR dataset.

The final output is a "Consolidated_stats.csv" file which will be placed in the "UCI HAR Dataset" folder.
