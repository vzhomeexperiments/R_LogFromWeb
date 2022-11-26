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

# URLs 
url1 <- "http://192.168.0.224/?s=1,0" #INFO Screen
url2 <- "http://192.168.0.224/?s=1,1" #HEAT PUMP Screen

####-----------------------------------------------------------
### INFO Screen
# get the raw data from web
stweb1 <- url1 %>% read_html()

# get the values 
values <- stweb1 %>% html_nodes(".value") %>% html_text()
# parse numbers
# replace commas with dots
values_d <- gsub(",", ".", values) %>% 
  readr::parse_number()

# get the categories
topics <- stweb1 %>% html_nodes(".key") %>% html_text()

# create data frame
data1 <- data.frame(topics, values_d, values, stringsAsFactors = FALSE) #%>% View()

# transpose and rename
data1_t <- data.frame(t(values_d))
names(data1_t) <- topics

####-----------------------------------------------------------
### HEAT PUMP Screen
# get the raw data from web
stweb2 <- url2 %>% read_html()

# get the values 
values <- stweb2 %>% html_nodes(".value") %>% html_text()
# parse numbers
# replace commas with dots
values_d <- gsub(",", ".", values) %>% 
  readr::parse_number()

# get the categories
topics <- stweb2 %>% html_nodes(".key") %>% html_text()

# create data frame
data2 <- data.frame(topics, values_d, values, stringsAsFactors = FALSE) #%>% View()

# transpose and rename
data2_t <- data.frame(t(values_d))
names(data2_t) <- topics
####-----------------------------------------------------------
# get current date and add it to the dataframe 
c_dt <- Sys.time() %>% as.data.frame() %>% rename(DateTime = ".")
### Join data 
c_data <- bind_cols(c_dt, data1_t, data2_t)

####-----------------------------------------------------------
### Data logging
# get user document folder
path_user <- normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')

#absolute path to store data
path_data <- file.path(path_user, "Documents", "HP_Logs")

# check if the directory exists or create
if(!dir.exists(path_data)){dir.create(path_data)}

f_name <- paste(Sys.Date(), ".csv")
f_path <- file.path(path_data, f_name)

# write file fist time
if(!file.exists(f_path)){
  write_csv(c_data, f_path)  
} else {
  # read and append to the file
  temp <- read_csv(f_path) 
  bind_rows(temp, c_data) %>% write_csv(f_path)
}

# there will be one file for every day when the R program is running