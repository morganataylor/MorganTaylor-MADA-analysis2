###############################
# processing script
#
#this script loads the raw data, processes and cleans it 
#and saves it as Rds file in the processed_data folder

#load needed packages. make sure they are installed.
library(readxl) #for loading Excel files
library(dplyr) #for data processing
library(here) #to set paths
library(stringr) #to remove oddly formatted time stamp

#define path to data
data_location <- here::here("data","raw_data","covid-data.csv")

#load data. 
#note that for functions that come from specific packages (instead of base R)
rawdata <- read.csv(data_location)

#take a look at the data
dplyr::glimpse(rawdata)

#determine total number of missing values
sum(is.na(rawdata))

#remove missing data (since relatively few missing data)
processeddata <- rawdata %>% 
                    stats::na.omit()

#remove the trailing characters of time data
#can't be included in the previous piping statement as stringr treats piping as additional argument
processeddata$Date.Administered <- 
  stringr::str_sub(processeddata$Date.Administered, 1, 
                   nchar(processeddata$Date.Administered)-9)

# save data as RDS
# location to save file
save_data_location <- here::here("data","processed_data","processeddata.rds")
saveRDS(processeddata, file = save_data_location)

