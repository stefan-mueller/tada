#####################################################
#################### Upload Functions  ##############
#####################################################

df_container <- reactiveValues(df = NULL,
                               upload_check = FALSE,
                               format_check = FALSE,
                               text_var = "",
                               doc_var = "",
                               info_text= "Please upload a file or use the sample corpus!",
                               info_color = "red",
                               info_icon = "info")

corpus_container <- reactiveValues(corp = NULL,
                                   corpus_check = FALSE,
                                   reshape_check = FALSE)

# NOTE: This file reads in the dataset (currently only spreadsheets)

observe({
  if(!df_container$format_check) {
    shinyjs::disable("set_vars")
  } else {
    shinyjs::enable("set_vars")
  }
})

observe({
  if(is.null(input$uploaded_file) || input$uploaded_file == "") {
    shinyjs::disable("upload_file")
  } else {
    shinyjs::enable("upload_file")
  }
})

observe({
  if(df_container$format_check) {
    shinyjs::show("upload_data_info")
  } else {
    shinyjs::hide("upload_data_info")
  }
})

########## READ UPLOAD DATA

observeEvent(input$upload_file, { 
  
  if(!input$use_default){
    
    if(is.data.frame(input$uploaded_file)){
      inFile <- input$uploaded_file
      extension <- tolower(tools::file_ext(inFile$name))
      if(extension == "dta"){
        df_container$df <- read_external_shiny()
      } else if(extension == "sav"){
        df_container$df <- read_external_shiny()
      } else if(extension == "xlsx"){
        df_container$df <- read_xlsx_shiny()
      } else if(extension == "csv"){
        df_container$df <- read_csv_shiny()
      } else if(extension == "rds"){
        df_container$df <- read_rds_shiny()
      } else{ # ==> data not supported
        df_container$df <- NULL
        df_container$format_check <- FALSE
        df_container$text_var <- ""
        df_container$doc_var <- ""
        df_container$info_text <- "Data format is not supported!"
        df_container$info_color <- "red"
        df_container$info_item <- "warning"
        shinyalert::shinyalert("Error!",
                               "Wrong data format. Please upload a new file in a different format.", 
                               type = "error")
      }
    } else{ # ==> No file selected
      shinyalert::shinyalert("Info!",
                             "Please select a file.",
                             type="info")
      df_container$df <- NULL
      df_container$upload_check <- FALSE
      df_container$format_check <- FALSE
      df_container$text_var <- ""
      df_container$doc_var <- ""
      df_container$info_text <- "Please upload a file or use the sample corpus!"
      df_container$info_color <- "red"
      df_container$info_item <- "warning"
    }
  }
  
  if(is.data.frame(df_container$df)){
    df_container$upload_check <- TRUE
    df_container$format_check <- TRUE
  }
  
  if(df_container$format_check){ # ==> IF DATA UPLOAD SUCCESSFULL!
    
    df <- df_container$df
    cnames <- colnames(df)
    
    # Guess Variable!
    
    if(df_container$text_var != "" & df_container$text_var %in% cnames){
      
      df_container$info_text <- paste0("Data uploaded successfully! You have chosen '", df_container$text_var, "' as text variable.")
      df_container$info_color <- "green"
      df_container$info_item <- "info"
    
    } else{  
      
      char_vars <- sapply(df, is.character) # get only char vars
    
      if(sum(char_vars) == 0){
        
        shinyalert::shinyalert("Warning!",
                               "No column of your data contains text.", 
                               type = "warning")
      
      } else{ # ==> DATA CONTAINS TEXT
        
        rows <- nrow(df) # number of rows
        if(rows > 10) rows <- 10 # if more than 10 rows, then only use top ten (more efficient)
        text_length <- apply(df[1:rows, char_vars], 2, function(x) sum(nchar(x))) # sum of chars in all char-vars for first ten obs
        text_var <- names(which.max(text_length)) # get var max
        if(length(text_var) > 1) text_var <- text_var[1] # in case of identical lengths (very unlikely!!!)
        df_container$text_var <- text_var
        df_container$info_text <- paste0("Data uploaded successfully! The variable '", text_var, "' was chosen as text variable automatically. You can change this by using the menu on the top-right.")
        df_container$info_color <- "olive"
        df_container$info_item <- "info"
     }
    }
   } # end of data check
  
})

########## READ DEFAULT DATA

observeEvent(input$use_default == TRUE | input$use_default == FALSE, { 
  
  if(input$use_default == TRUE){  
    df_container$df <- as.data.frame(readRDS(file = "data/manifestos_ireland.rds"))
    df_container$upload_check <- TRUE
    df_container$format_check <- TRUE
    df_container$text_var <- "text"
    df_container$doc_var <- "doc_id"
    df_container$info_text <- paste("You are now using the default text corpus of Irish Party Manifestos. Text and Document variables have been selected automatically and cannot be changed.")
    df_container$info_color <- "blue"
    df_container$info_item <- "info"
  } else{
    df_container$df <- NULL
    df_container$upload_check <- FALSE
    df_container$format_check <- FALSE
    df_container$text_var <- ""
    df_container$doc_var <- "" 
    df_container$info_text <- "Please upload a file or use the sample corpus!"
    df_container$info_color <- "red"
    df_container$info_item <- "warning"
  }
})

###################### Text and Doc Var Variables

observe({
  if(df_container$format_check) {
    
    char_var <- sapply(df_container$df, is.character)
    char_var <- names(df_container$df)[char_var]
    
    choices = data.frame(
      var = char_var,
      num = 1:length(char_var),
      stringsAsFactors = FALSE
    )
    
  } else {
    
    char_var <- sapply(df_container$df, is.character)
    char_var <- names(df_container$df)[char_var]
    
    choices = data.frame(
      var = c("", ""),
      num = 1:2,
      stringsAsFactors = FALSE
    )
  }
  
  output$set_vars_ui <- renderUI({
    tagList(
    selectInput("text_var", "Name of Text Variable", as.list(choices$var), selected = as.list(choices$var)[[1]]),
    selectInput("doc_var", "Name of Document ID Variable", as.list(choices$var), selected = as.list(choices$var)[[2]]),
    actionButton("set_vars", "Set Text and Doc Variables!", width = "100%",
                 style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
    )
  })
  
})

observeEvent(input$set_vars, {

  if(input$use_default == TRUE){  
    
    shinyalert::shinyalert("Info!",
                           "You are using the default corpus. Text variable and document ID cannot be changed.",
                           type = "info")
  
  } else{ 
  
    if(!df_container$format_check){
    
      shinyalert::shinyalert("Error!",
                             "Please upload a data set.",
                             type = "error")
  
    } else{
    
      if(input$text_var == ""){
        shinyalert::shinyalert("Error!",
                               "Please enter the name of the text variable.",
                               type = "error")
      } else{
        if(!(input$text_var %in% colnames(df_container$df))) shinyalert::shinyalert("Error", "Your text variable does not exist in the data.", type = "error") else df_container$text_var <- input$text_var
        if(!(input$doc_var %in% colnames(df_container$df))) shinyalert::shinyalert("Error", "Your document ID variable does not exist in the data.", type = "error") else df_container$doc_var <- input$doc_var
      }
    }
  }
})

################## HELPER FUNCTIONS

read_csv_shiny <- reactive({
  
  inFile <- input$uploaded_file
  
  data.table::fread(inFile$datapath, 
                    header = TRUE,
                    sep = input$csv_delim,
                    data.table = FALSE)
  
})

read_xlsx_shiny <- reactive({
  
  inFile <- input$uploaded_file
  
  extension <- tools::file_ext(inFile$name)
  
  file.rename(inFile$datapath,
              paste(inFile$datapath, extension, sep="."))
  
  as.data.frame(read_excel(paste(inFile$datapath, extension, sep="."), 1), stringsAsFactors = FALSE)
  
})

read_external_shiny <- reactive({
  
  inFile <- input$uploaded_file
  
  ext <- tools::file_ext(inFile$name)
  
  if(ext == "dta") df <- as.data.frame(read_dta(inFile$datapath), stringsAsFactors = FALSE)
  if(ext == "sav") df <- as.data.frame(read_sav(inFile$datapath), stringsAsFactors = FALSE)
  
  df
})

read_rds_shiny <- reactive({
  
  inFile <- input$uploaded_file
  
  readRDS(inFile$datapath)
  
})