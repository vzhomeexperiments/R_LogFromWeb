# Read data from local web page and log data
# Lazy Trading Course: Read news and Sentiment Analysis
# Sub Theme: Optimization of Home Energy Use
# (C) 2022 Vladimir Zhbanko
# https://www.udemy.com/course/forex-news-and-sentiment-analysis/?referralCode=2B76F54F1D33CF06B79C

# load libraries
library(rvest)
library(lubridate)
library(stringr)
library(magrittr)
library(tidyr)
library(readr)
library(dplyr)

# summary of actions
# import data from the IoT device
# get url data columns
# create data frame
# transpose data and log it

# URLs - log data from Wallbox
url1 <- "http://192.168.0.44/status.shtml" #INFO Screen

####-----------------------------------------------------------
### INFO Screen
# get the raw data from web
stweb1 <- url1 %>% read_html()

# get the values 
values <- stweb1 %>% html_table()

log_titles <- values[[2]][["X1"]] 
log_values <- values[[2]][["X2"]]


# create data frame
data1 <- data.frame(log_titles, log_values, stringsAsFactors = FALSE) #%>% View()


# transpose and rename
data1_t <- data.frame(t(log_values))
names(data1_t) <- log_titles

####-----------------------------------------------------------
# get current date and add it to the dataframe 
c_dt <- Sys.time() %>% as.data.frame() %>% rename(DateTime = ".")
### Join data 
c_data <- bind_cols(c_dt, data1_t)

####-----------------------------------------------------------
### Data logging
# get user document folder
path_user <- normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')

#absolute path to store data
path_data <- file.path(path_user, "Documents", "HP_Logs")

# check if the directory exists or create
if(!dir.exists(path_data)){dir.create(path_data)}

f_name <- paste0(Sys.Date(), "WB", ".csv")
f_path <- file.path(path_data, f_name)

# write file fist time
write_csv(c_data, f_path)  

# there will be one file for every day when the R program is running