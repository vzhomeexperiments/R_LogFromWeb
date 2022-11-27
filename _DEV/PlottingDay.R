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

# read file
f_name <- paste0(Sys.Date(),"HP", ".csv")
f_path <- file.path(path_data, f_name)

temp <- read_csv(f_path)

####-----------------------------------------------------------
### Clean, select variables, visualize

# room temperature vs time
temp %>% 
  select(1, 2) %>% 
  ggplot(aes(DateTime, `ACTUAL ROOM T HC1`))+geom_line()

# relative humidity vs room temperature
temp %>% 
  select(2, 4) %>% 
  ggplot(aes(`ACTUAL ROOM T HC1`, `RELATIVE HUMIDITY HC1`))+geom_point()

# temperature outside vs temperature inside
temp %>% 
  select(2, 8, 29) %>% 
  ggplot(aes(`ACTUAL ROOM T HC1`,
             `OUTSIDE TEMPERATURE`,
             col = as.factor(`HEATING STAGE`)
             ))+
  geom_point()

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

