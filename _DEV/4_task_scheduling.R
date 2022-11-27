# 20221126 Task Scheduling Automation from R
# https://cran.r-project.org/web/packages/taskscheduleR/readme/README.html
#
# =====================================
# Script to deploy lazytrading tasks automatically
library(taskscheduleR)
library(secret)
# =====================================
# Common setup & secure password management
# =====================================
path_user <- normalizePath(Sys.getenv('PATH_DSS'), winslash = '/')
who_user <-  normalizePath(Sys.getenv('USERPROFILE'), winslash = '/')
# create your private/public keys (e.g. in R Studio)
path_keys <- file.path(who_user, ".ssh")
# decrypt credentials
password <- secret::get_secret("pwrd",
                               key = file.path(path_keys, 'id_rsa'),
                               vault = file.path(path_user, "vault"))
usr <- secret::get_secret("user",
                          key = file.path(path_keys, 'id_rsa'),
                          vault = file.path(path_user, "vault"))
## don't like to bother with security?
# usr <- ""
# password <- ""
extra_parameters <- paste0("/RU ", usr, " ", "/RP ",password)

# =====================================
# Task: automate script 
# =====================================
script_name <- 'ReadingWeb.R'
path_script <- file.path(who_user, "Documents", "GitHub", "R_LogFromWeb", "_DEV", script_name)

## Delete task
taskscheduler_delete("hp_log")

## Setup task
taskscheduler_create(taskname = "hp_log", rscript = path_script,
                     schedule = "HOURLY",
                     starttime = "00:01",
                     schtasks_extra = extra_parameters)

# =====================================
# Task: automate script 
# =====================================

script_name <- 'ReadingWebWB.R'
path_script <- file.path(who_user, "Documents", "GitHub", "R_LogFromWeb", "_DEV", script_name)

## Delete task
taskscheduler_delete("wb_log")

## Setup task
taskscheduler_create(taskname = "wb_log", rscript = path_script,
                     schedule = "DAILY",
                     starttime = "08:01",
                     schtasks_extra = extra_parameters)
