# Read data from file and visualize
# Lazy Trading Course: Read news and Sentiment Analysis
# Sub Theme: Optimization of Home Energy Use
# (C) 2022 Vladimir Zhbanko
# https://www.udemy.com/course/forex-news-and-sentiment-analysis/?referralCode=2B76F54F1D33CF06B79C

# load libraries
library(lubridate)
library(stringr)
library(magrittr)
library(readr)
library(dplyr)
library(ggplot2)

# summary of actions
# import data from file
####-----------------------------------------------------------
### Data logging
# get user document folder
path_user <- normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')

#absolute path to store data
path_data <- file.path(path_user, "Documents", "HP_Logs")

#define number of days to plot
n_days <- 10

# read files
l_files <- list.files(path = path_data, pattern = "HP.csv", full.names = TRUE) %>% tail(n_days)

for (FILE in l_files) {
  #FILE <- l_files[1]
  if(!exists("temp")){
    temp <- read_csv(FILE)
  } else {
    temp1 <- read_csv(FILE)
    temp <- bind_rows(temp, temp1)
  }
  
}

# f_name <- paste0(Sys.Date(),"HP", ".csv")
# f_path <- file.path(path_data, f_name)
# 
# temp <- read_csv(f_path)

####-----------------------------------------------------------
### Clean, select variables, visualize

# room temperature vs time
temp %>% 
  select(1, 2) %>% 
  ggplot(aes(DateTime, `ACTUAL ROOM T HC1`))+geom_line()

# room temperature vs time with plotted fit
temp %>% 
  select(1, 2) %>% 
  ggplot(aes(DateTime, `ACTUAL ROOM T HC1`))+geom_line()+
  geom_smooth()

# relative humidity vs room temperature
temp %>% 
  select(2, 4, 29) %>% 
  ggplot(aes(`ACTUAL ROOM T HC1`,
             `RELATIVE HUMIDITY HC1`,
             col = as.factor(`HEATING STAGE`)))+
  geom_point()+
  geom_smooth()
# temperature outside vs temperature inside
temp %>% 
  select(2, 8, 29) %>% 
  ggplot(aes(`ACTUAL ROOM T HC1`,
             `OUTSIDE TEMPERATURE`,
             col = as.factor(`HEATING STAGE`)
             ))+
  geom_point()+
  geom_smooth()

# hot gas pressure vs time
temp %>% 
  select(1, 32) %>% 
  ggplot(aes(DateTime, `HIGH PRESSURE`))+geom_line()

# dhw temp vs time
temp %>% 
  select(1, 18) %>% 
  ggplot(aes(DateTime, `DHW SET TEMPERATURE`))+geom_line()

# heat recovery vs time
temp %>% 
  select(1, 47) %>% 
  ggplot(aes(DateTime, `HEAT M RECOVERY DAY`))+geom_line()

# power used heating vs time
temp %>% 
  select(1, 54) %>% 
  ggplot(aes(DateTime, `PWR CON HTG DAY`))+geom_line()

# power used vs temperature outside
temp %>% 
  select(2, 8, 54) %>% 
  ggplot(aes(`OUTSIDE TEMPERATURE`,
             `PWR CON HTG DAY`,
             size = `ACTUAL ROOM T HC1`))+geom_point()

