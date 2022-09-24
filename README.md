# Data Description  
The observations in the attached CSV files have been taken from the Bureau of Meteorology’s “real time” system. These observations provide some details about the weather in the Australian Capital territory for 39 months. Most of the data are generated automatically. Some quality checking has been performed, but it is still possible for erroneous values to appear. Sometimes, when the daily maximum and minimum temperatures, rainfall or evaporation are missing, the next value given has been accumulated over several days rather than the normal one day.  
  

There are 39 comma-separated data files provided with this assignment. These data are for the months from August 2018 to February 2022, (with some months were skipped). The variables reported in each file are described in Table 1.  
  


# Copyright of Data  
Copyright of Bureau of Meteorology materials resides with the Commonwealth of Australia. Apart from any fair dealing for purposes of study, research, criticism and review, as permitted under copyright legislation, no part of this product may be reproduced, re-used or redistributed for any commercial purpose whatsoever, or distributed to a third party for such purpose, without written permission from the Director of Meteorology.  
  


# Data preparation:  
A few of the datasets has date set as US-date format, at the beginning of the data cleansing process all Date columns from each 39 file has been converted into R default YYYY-MM-DD format.  
  

# Summary:   
We start with exploring the data.  
Adding all the data to a single data frame.  
Make necessary changes to the data type in the data frame.  
Drop any column that has no value.  
Drop any column that has more than 90% NA values.  
Replace NA values from all numeric columns with median values.  
Create a month and year columns.  
Assign levels to the month and column.  
At the end, store the clean data as a csv file. 