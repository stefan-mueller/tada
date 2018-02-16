# Use packman package to check whether required packages are installed.
# Install missing packages, and load all packages afterwards

if(!require(pacman)) install.packages("pacman")

#library(shiny)
#library(shinydashboard)
#library(shinyjs)
#library(quanteda)
#library(ggplot2)
#library(data.table)
#library(stringr)
#library(readxl)
#library(haven)
#library(topicmodels)
#library(ggridges)

pacman::p_load(shiny, 
               shinyalert,
               shinydashboard,
               shinyjs,
               quanteda,
               ggplot2,
               dplyr,
               data.table,
               stringr,
               readxl,
               haven,
               topicmodels,
               ggridges)

source("ui_tada.R", local = TRUE)$value
source("server_tada.R", local = TRUE)$value
enableBookmarking("url")
shinyApp(ui, server) # launch app

