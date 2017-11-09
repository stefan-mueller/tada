
# Load the app here

library(shiny)
library(shinydashboard)
library(quanteda)
library(ggplot2)
library(tidyverse)
library(readxl)
library(haven)
library(stringr)
library(topicmodels)
library(data.table)
library(ggridges)
library(shinyjs)

source("ui_tada.R", local = TRUE)$value
source("server_tada.R", local = TRUE)$value
enableBookmarking("url")
shinyApp(ui, server) # launch app

