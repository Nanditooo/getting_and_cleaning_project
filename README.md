Coursera: Getting and Cleaning Data Project repository
============================

This repository contains files for Getting and Cleaning Project.
The `run_analysis.R` file is the project code, and the `CodeBook.md` is the codebook of data.

## Script
The `run_analysis.R` code performs the following steps
  1. Change the working directory.
  2. If the raw data zip does not exists download it from web using an url and unzip it.
  3. Read activity labels and features from the unzipped txt files.
  4. Using `grepl` function check which feuters name contains "mean" or " std" string. It was a little bit tricky, because grepl is case sensitive, therefore "Mean" string is also required.
  5. Replace "," and "-" strings with `gsub` function to "_" one.
  6. Remove "()" strings with `gsub` function.
  7. Read test and train data sets.
  8. Create a new variable in train and test activity data which contains the name of activities.
  9. Create names to the variables in test and train data sets.
  9. Choose just those variables from train and test data which contains "mean" and "str" string
  10. Merge the subject, activity labels and data sets for train and test data.
  10. Merge train and test data to one object.
  11. Loading `data.table` library to use `data.table[, lapply(.SD, mean), by=list(subject, activity_labels)]` function to create the mean value of all variables for each subject and activity labels.
  12. Reorder the tidy data and write it to a txt file.

## Data
If you would like to read about the data and the meaning of variable names, please check the `CodeBook.md` file!

