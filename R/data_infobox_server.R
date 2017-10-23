################################################################
#################### Helper Functions Upload Page ##############
################################################################

get_colnames <- reactive({
  
  if(df_container$format_check){
    colnames(df_container$df)
  }
  
})

get_coltypes <- reactive({
  
  if(df_container$format_check){
    col_names <- get_colnames()
    types <- sapply(df_container$df, class)
    return(data.frame("Variable" = col_names, "Type" = types, stringsAsFactors = F))
  }
  
})

observe({
  if(df_container$format_check){
    if(df_container$doc_var == "") corp <- corpus(df_container$df, text_field = df_container$text_var)
    if(df_container$doc_var != "") corp <- corpus(df_container$df, text_field = df_container$text_var, docid_field = df_container$doc_var)
    corpus_container$corp <- corp
    corpus_container$corpus_check <- TRUE
    corpus_container$reshape_check <- FALSE
  } else{
    corpus_container$corp <- NULL
    corpus_container$corpus_check <- FALSE
    corpus_container$reshape_check <- FALSE
  }
})  

############# Output

# Table with coltypes

output$report_coltypes <- renderDataTable({
  
  validate(need(df_container$format_check, "The table will be displayed here once you've uploaded your data."))
  
  get_coltypes()
  
})

# Full Data Output

output$full_data <- renderDataTable({
  
  validate(need(df_container$upload_check, "The table will be displayed here once you've uploaded your data."))

  corp <- corpus_container$corp
  
  df <- docvars(corp)
  
  n_cols <- ncol(df)
  
  if(n_cols > 8) n_cols <- 8
  
  return(df[,1:n_cols])
})

# Create Infobox

output$info_text <- renderInfoBox({
  
  infoBox(value = df_container$info_text, title = "data info", color = df_container$info_color, icon = icon(df_container$info_icon))
  
})