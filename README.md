# getcleandata
Programming Assignment 4
This program takes multiple different related data sources from the UCI wearables data set and binds the data together, clarifies the output with more descriptive names, and produces a single tidied output file. 

First, we read test, training, and activity data from source files provided by UCI for wearable computing, available at:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data was extracted from the achive and placed in our R working directory.  First, we examine the data and associated documentation to get an idea of how it is structured.  
Next we bind training and test values, set column names, and bind features, activity, and subject data.  
Then we search for column names with measures of interest, get those indices and extract that data to new variable, making sure to include activity and subject!
Then we set activity from activity labels, set the names for the measures to more understandable values, and finally write the tidy data set to a file.
