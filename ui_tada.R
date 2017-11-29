ui <- function(req){
  
              dashboardPage(skin = "black", title = "TADA - The Text as Data App", 
                    
                    # Header
                    source("dashboardHeader.R", local = T)$value,
                    
                    # Sidebar
                    source("sidebar.R", local = TRUE)$value,
                    
                    # Body
                    dashboardBody(useShinyjs(),
                      tabItems(
                        tabItem(tabName = "data_upload", source("ui/data_upload.R", local = TRUE)$value),
                        tabItem(tabName = "subset_reshape_corpus", source("ui/subset_reshape_corpus.R", local = TRUE)$value),
                        tabItem(tabName = "kwic", source("ui/kwic.R", local = TRUE)$value),
                        tabItem(tabName = "keyness", source("ui/keyness.R", local = TRUE)$value),
                        tabItem(tabName = "create_dfm", source("ui/create_dfm.R", local = TRUE)$value),
                        tabItem(tabName = "wordscores", source("ui/wordscores.R", local = TRUE)$value),
                        tabItem(tabName = "wordfish", source("ui/wordfish.R", local = TRUE)$value),
                        tabItem(tabName = "ca", source("ui/ca.R", local = TRUE)$value),
                        tabItem(tabName = "topicmodel", source("ui/topicmodel.R", local = TRUE)$value),
                        tabItem(tabName = "about", source("ui/about.R", local = TRUE)$value)
                      )
                    )
) # end user interface

}
# subset_reshape_corpus