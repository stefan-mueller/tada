# Ueber die Seite laedt man die App!

library(shinyjs)
source("uix.R", local = TRUE)$value
source("serverx.R", local = TRUE)$value
enableBookmarking("url")
shinyApp(ui, server) # launch app
