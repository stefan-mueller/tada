
# Use packman package to check whether required packages are installed.
# Install missing packages, and load all packages afterwards

if (!require("pacman")) install.packages("pacman")

pacman::p_load(shiny, 
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

