library(shiny)
library(shinydashboard)
library(quanteda)
library(tidyverse)
library(readxl)
library(haven)
library(stringr)
library(topicmodels)
library(data.table)
library(ggridges)
library(shinyjs)

ui <- function(req){
  
              dashboardPage(skin = "black", title = "TADA - The Text as Data App", 
                    
                    # Header
                    source("dashboardHeader.R", local = T)$value,
                    
                    # Sidebar
                    source("sidebar.R", local = TRUE)$value,
                    
                    # Body
                    dashboardBody(useShinyjs(),
                      tabItems(
                        tabItem(tabName = "data_upload", source("data_upload/data_upload.R", local = TRUE)$value),
                        tabItem(tabName = "subset_reshape_corpus", source("subset_reshape_corpus/subset_reshape_corpus.R", local = TRUE)$value),
                        tabItem(tabName = "kwic", source("kwic/kwic.R", local = TRUE)$value),
                        tabItem(tabName = "create_dfm", source("create_dfm/create_dfm.R", local = TRUE)$value),
                        tabItem(tabName = "wordscores", source("wordscores/wordscores.R", local = TRUE)$value),
                        tabItem(tabName = "wordfish", source("wordfish/wordfish.R", local = TRUE)$value),
                        tabItem(tabName = "ca", source("ca/ca.R", local = TRUE)$value),
                        tabItem(tabName = "topicmodel", source("topicmodel/topicmodel.R", local = TRUE)$value),
                        tabItem(tabName = "about", source("about/about.R", local = TRUE)$value)
                      )
                    )
) # end user interface

}
# subset_reshape_corpus