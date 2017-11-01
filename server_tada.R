server <- function(input, output, session){
  
  # Function which checks for object existence
  
  is.valid <- function(x) {
    is.null(need(x, message = FALSE))  
  }
  
  ########################################################################
  #   Server Function implements all the functions required by the app   #
  ########################################################################
  
  # This option increases the max upload file size to 3,000 MB
  
  options(shiny.maxRequestSize=3000*1024^2)
  
  # Loop through all .R file in the subfolder "/R" and load them
  
  for (r_file in list.files(path = "R", pattern = "\\.R$")) { # pattern = regex: only files which end with ".R"
    source(paste0("R/", r_file), local = TRUE)$value # paste0 adds path to the file...local = due to shiny
  }
  
}