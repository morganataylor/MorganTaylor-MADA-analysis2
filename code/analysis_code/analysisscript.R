###############################
# analysis script
#
#this script loads the processed, cleaned data, does a simple analysis
#and saves the results to the results folder

#load needed packages. make sure they are installed.
library(tidyverse)
library(ggplot2) #for plotting
library(broom) #for cleaning up output from lm()
library(here) #for data loading/saving

#path to data
#note the use of the here() package and not absolute paths
data_location <- here::here("data","processed_data","processeddata.rds")

#load data. 
mydata <- readRDS(data_location)

######################################
#Data exploration/description
######################################
#I'm using basic R commands here.
#Lots of good packages exist to do more.
#For instance check out the tableone or skimr packages

#summarize data 
mysummary = summary(mydata)

#look at summary
print(mysummary)

#do the same, but with a bit of trickery to get things into the 
#shape of a data frame (for easier saving/showing in manuscript)
summary_df = data.frame(do.call(cbind, lapply(mydata, summary)))

#save data frame table to file for later use in manuscript
summarytable_file = here("results", "summarytable.rds")
saveRDS(summary_df, file = summarytable_file)

# Create a plot that shows number of number of administered doses percentage for each age group 
plot1 <-mydata %>% ggplot(aes(x=AgeGroupVacc,y=Administered_Dose1_pct_agegroup))+
                geom_line()+
                labs(x="Age_group", y="Dose", title= "Flu Shot Doses")
#look at figure
plot(plot1)

# Create a plot that shows number of avg group cases for each age group
plot2 <- mydata %>% ggplot(aes(x=AgeGroupVacc,y=X7.day_avg_group_cases_per_100k))+
      geom_line()+
     labs(x="Age_group", y="avg_group_cases", title= "Cumulative Flu Shot Doses")

#look at figure
plot(plot2)

#save figure
figure_file1 = here("results","resultfigure1.png")
ggsave(filename = figure_file1, plot=plot1)  

#save figure
figure_file2 = here("results","resultfigure2.png")
ggsave(filename = figure_file2, plot=plot2) 

# fit linear model
lmfit <- lm(X7.day_avg_group_cases_per_100k ~ Administered_Dose1_pct_agegroup, mydata)  
lmfit2 <- lm(X7.day_avg_group_cases_per_100k ~ Series_Complete_Pop_pct_agegroup, mydata)


# place results from fit into a data frame with the tidy function
lmfittable <- broom::tidy(lmfit)
lmfit2table <- broom::tidy(lmfit2)

#look at fit results
print(lmfittable)
print(lmfit2table)


# save fit results table  
dose_file = here("results", "resulttable.rds")
saveRDS(lmfittable, file = dose_file)

avgcase_file = here("results", "resulttable1.rds")
saveRDS(lmfit2table, file = avgcase_file)

  