# install and load tidyverse package.

install.packages("tidyverse")
library(tidyverse)

#aus format
#parse date will output in the following format : yyyy-mm-dd

AU_Date_Format <- "%d/%m/%Y"
str(as.Date("20/10/2020", format = AU_Date_Format))
str(as.Date("21/11/2021", format = AU_Date_Format))

#Similarly in usFormat format is (month, day, year).

US_Date_Format <- "%m/%d/%Y"
str(as.Date("10/20/2020", format = US_Date_Format))
str(as.Date("11/21/202", format = US_Date_Format))

#string vector of all the names with .csv extension

files <- list.files(pattern = ".csv")

#Read all the csv files in one dataframe
#fixed all date formats
#skipped beginning comments up to row 7
#skipped header

for(i in 1:length(files)){
  data <- read_csv(files, col_names = TRUE, show_col_types = FALSE,  skip = 7)  
  ausFormat <- as.Date(data$Date, format = "%m/%d/%Y")
  usFormat <- as.Date(data$Date, format = "%d/%m/%Y")
  ausFormat[is.na(ausFormat)] <- usFormat[!is.na(usFormat)]
  data$Date <- ausFormat
  act_weather_data <- data
}

#Removed all the unnecessary objects in the Environment.

rm(data, ausFormat, usFormat, files, i)

#Number of rows and columns  of the data frame.

dim(act_weather_data)

#structure of the data frame

str(act_weather_data)

# check how many times at max, any particular date is present in the data frame

act_weather_data %>% group_by(Date) %>% summarise(count=n()) %>%
  summarise(max = max(count))

# number of NA's in each feature
act_weather_data %>% summarise_all(funs(sum(is.na(.)))) %>% 
  gather() %>% filter(value > 0)


# save date frame as a csv file

write.csv(act_weather_data, file="act_weather_part_A.csv")


#Remove the 5th(Evaporation (mm))  and 6th(Sunshine (hours)) variables from the data frame, as they had all NA's.

columnToRemove <- colnames(act_weather_data)[colSums(is.na(act_weather_data)) == 1186]
act_weather_data <- act_weather_data[ , !(names(act_weather_data) %in% columnToRemove)]


#Check if there is more than 90% NA's

threshold90 <- (nrow(act_weather_data) %/% 100) * 90
act_weather_data %>% summarise_all(funs(sum(is.na(.)))) %>% 
  gather() %>% filter(value >= threshold90)
# no feature has 90% or more data missing


# fix column names.

colnames(act_weather_data) <- gsub(" ", "_", colnames(act_weather_data))


# str(act_weather_data) will show my data feature is alreay on Date format

str(act_weather_data)

# as.date function we can change date  variable type from character to date.

act_weather_data$Date <- as.Date(act_weather_data$Date, "%Y/%m/%d")


# add two new variables month and year
# adding 2000 with the year variable will get the whole year

act_weather_data <- mutate(act_weather_data, 
                           month = strftime(act_weather_data$Date, "%m"), 
                           year = as.integer(strftime(act_weather_data$Date, "%y")) + 2000)


# to order them use the levels as (1:12) and "unique" to  return variable in string format and then assign the level

act_weather_data$month <- factor(act_weather_data$month, levels = unique(act_weather_data$month), labels = 1:12)

# create a vector which contains a sequence of numbers from 1 to the length of the object which is 5

act_weather_data$year <- factor(act_weather_data$year, levels = sort(unique(act_weather_data$year)), 
                                labels = seq_along(sort(unique(act_weather_data$year))))

# there are three numeric columns which have NA values, which are "Speed_of_maximum_wind_gust(km/h)", "9am_Temperature" and "3pm_Temperature)".
# assign the median values where there was NA as value.

# getting all the numeric columns
numericColumns <- act_weather_data[colnames(act_weather_data[unlist(lapply(act_weather_data, is.numeric))])]
# getting the column names that has NA value
naColumnNames <- colnames(numericColumns)[colSums(is.na(numericColumns)) > 0]
# iterate through the column names and assign median value
for (name in naColumnNames){
  temp <- as.numeric(unlist(act_weather_data[name]))
  act_weather_data[name][is.na(act_weather_data[name])] <- median(temp, na.rm = TRUE)
}

#save the file

write.csv(act_weather_data, file="act_weather_part_B.csv")



