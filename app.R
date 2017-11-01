# Load the app here

library(shinyjs)
source("ui_tada.R", local = TRUE)$value
source("server_tada.R", local = TRUE)$value
enableBookmarking("url")
shinyApp(ui, server) # launch app
