
#####################################################
#################### Corpus Page ####################
#####################################################

# NOTE: This file creates quanteda corpus object
# from the dataframe and allows to subset the corpus

observe({
  if(!corpus_container$corpus_check) {
    shinyjs::disable("reshape")
    shinyjs::disable("subset_corpus")
    shinyjs::disable("get_display_text")
  } else {
    shinyjs::enable("reshape")
    shinyjs::enable("subset_corpus")
  }
})

observe({
  if(input$text_selector == "" | !corpus_container$corpus_check) {
    shinyjs::disable("get_display_text")
  } else {
    shinyjs::enable("get_display_text")
  }
})

observe({
  if(!corpus_container$reshape_check) {
    shinyjs::disable("download_reshape_data")
  } else {
    shinyjs::enable("download_reshape_data")
  }
})

observeEvent(input$reshape, {
  
  corp <- corpus_container$corp
  unit_corpus <- settings(corp)$units
  
  # if documents --> RESHAPE!
  
  if(unit_corpus == "documents"){ # if corpus is at document level
    
    corpus_container$corp <- corpus_reshape(corp, to = input$reshape_corpus)
    corpus_container$reshape_check <- TRUE   
  }
  
  if(unit_corpus == "paragraphs"){ # if corpus is at document level
    
    if(input$reshape_corpus == "sentences") shinyjs::alert("You cannot reshape to sentences from a corpus of paragraphs.")
    if(input$reshape_corpus == "paragraphs") shinyjs::alert("Your data is already reshaped to paragraphs.")
    
  }
  
  if(unit_corpus == "sentences"){ # if corpus is at document level

    if(input$reshape_corpus == "paragraphs") shinyjs::alert("You cannot re-aggregate your data.")
    if(input$reshape_corpus == "sentences") shinyjs::alert("Your data is already reshaped to sentences.")
    
  }
  
})



create_short_summary_table <- reactive({
  
  corp <- corpus_container$corp
  
  sum_corp <- summary(corp, n = 10^7, verbose = FALSE, showmeta = TRUE)
  
  n_vars <- ncol(docvars(corp))
  n_docs <- ndoc(corp)
  tokens <- mean(sum_corp$Tokens, na.rm = TRUE)
  sentences <- mean(sum_corp$Sentences, na.rm = TRUE)
  
  df <- data.frame(Information = c("Number of variables", "Number of documents", "Average number of tokens","Average number of sentences"), 
                   N = c(n_vars,n_docs, tokens, sentences), stringsAsFactors = FALSE)
  
  df
})


get_display_text <- eventReactive(input$get_display_text, {
  
  corp <- corpus_container$corp
  
  all_docs <- texts(corp)
  
  text_id <- input$text_selector
  
  if(!is.na(as.numeric(text_id))) text_id <- as.numeric(text_id)
  
  export_text <- all_docs[text_id]
  
  if(is.na(export_text)){
    shinyjs::alert("Text could not be found. Please enter a different document ID or number.")
    return(NULL)
  } else{
    return(export_text)
  }
  
})

################## Output

output$display_text <- renderText({
  
  validate(need(corpus_container$corpus_check, "Corpus does not exist."))
  validate(need(input$text_selector != "", "Please enter a text number or document ID."))
  validate(need(!is.null(get_display_text()), "Invalid document ID or text number."))
  
  get_display_text()
  
})

output$short_summary_table <- renderTable({
  
  validate(need(corpus_container$corpus_check, "Corpus does not exist."))
  
  create_short_summary_table()
  
}, width = "100%")

output$summary_table <- renderDataTable({
  
  validate(need(df_container$format_check, "The table will be displayed here once you've uploaded your data."))

  create_summary_table()
  
})


##############################################
##############################################
# Download Corpus
##############################################
##############################################

create_full_data <- reactive({
  
  corp <- corpus_container$corp
  
  texts <- texts(corp)
  
  meta <- docvars(corp)
  
  meta[[guess_textvar()]] <- texts
  
  meta
})

output$download_reshape_data = downloadHandler(
  
  filename = function() { paste0("corpus_df.csv") },
  
  content = function(file) {
    write.table(create_full_data(), file, sep = input$reshape_data_sep, na = "", row.names = FALSE)
  }
)
