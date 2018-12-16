#### The analysis file run_analysis.R uses dplyr package version 0.7.8 but may work on earlier versions as well

The analysis file downloads the data from the web and stores it in the working directory of the user

Loads training data from 3 files namely,
* X_train.txt
* Y_train.txt
* subject_train.txt

* X_train.txt file contains the variables
* Y_train.txt file contains the Activity information
* subject_train.txt contains the Subject information

In the next step the script combines the three data sets column wise.

The above steps are repeated for the test data using the following files,
* X_test.txt
* Y_test.txt
* subject_test.txt

In the next step the script combines the three data sets column wise.

Now the train and test data sets are combined row wise to form  one single data set using rbind()

Next step is to load Features data set using features.txt file and assign legible column names
The Features loaded in the previous step is used as column names for the large dataset obtained by combining test and train datasets; ActivityID and Subject are also added as the column names.

Next step is to load Activity dataset using activity_labels.txt file and assigning descriptive column names.

Next step is to merge the Activity data set with the large data set and get the descriptive activity name instead of the ActivityID


Next Step is to filter the Features dataset to just use the columns / variables which are used for Mean or Std Deviation

Next Step is to subset the large dataset using the filtered column list

Next we remove special characters from the column names, expand shortcodes and use more meaningful column names

Lastly we make a copy of the dataset created in the last step and group it by Activity and Subject and calculate averages of all the columns and write the output to a file using write.table function with row.names as FALSE.
