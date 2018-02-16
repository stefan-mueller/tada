#####################################################
#################### Functions DFM ##################
#####################################################  

# NOTE: This file creates a dfm and plots a 
# frequency plot/wordcloud
# (We might consider dividing both parts up, but for now I did not do it)

dfm_container <- reactiveValues(dfm = NULL,
                                dfm_check = FALSE,
                                dfm_nterms = NULL,
                                dfm_sparsity = NULL,
                                dfm_documents = NULL)

observeEvent(input$create_dfm, {
  
  if(!is.na(input$dfm_max_docfreq)){
    if(!(input$dfm_min_docfreq <= input$dfm_max_docfreq)){
      shinyalert::shinyalert("Error!",
                             "Min doc freq must be <= max doc freq!",
                             type = "error")
      return(NULL)
    }
  }
  
  if(!is.na(input$dfm_max_count)){
    if(!(input$dfm_min_count <= input$dfm_max_count)){
      shinyalert::shinyalert("Error!",
                             "Min doc count must be <= max doc count!",
                             type = "error")
      return(NULL)
    }
  }
  
  if(corpus_container$corpus_check){
    
    withProgress(message = 'Creating dfm...', value = 0, {
    
      corp <- corpus_container$corp
    
      incProgress(0.1, detail = "Remove Terms and Stem...")
    
      dfm_raw <- dfm(corp, tolower = input$lowercase == "yes_lower", 
                   stem = input$stemming == "yes_stem",
                   remove_punct = input$punctuation == "yes_punct",
                   remove_twitter = input$twitter == "yes_twitter",
                   remove_numbers = input$numbers == "yes_numb",
                   remove_symbols = input$symbols == "yes_symb",
                   remove_hyphens = input$hyphens == "yes_hyph",
                   remove_url = input$url == "yes_url",
                   remove_separators = input$separators == "yes_sep",
                   remove = create_stopwords()
      )
    
      incProgress(0.5, detail = "Remove Infrequent Terms...")
    
      dfm_infreq <- dfm_trim(dfm_raw, 
                           min_count = input$dfm_min_count, 
                           max_count = ifelse(is.na(input$dfm_max_count), 99999999, input$dfm_max_count), 
                           min_docfreq = input$dfm_min_docfreq, 
                           max_docfreq = ifelse(is.na(input$dfm_max_docfreq), 99999999, input$dfm_max_docfreq))
    
      incProgress(0.3, detail = "Remove Short Words...")
    
      dfm_short <- dfm_select(dfm_infreq, min_nchar = input$dfm_min_nchar)
    
    })
  
    if(nfeature(dfm_short)>0){
    
      dfm_container$dfm_check <- TRUE
      dfm_container$dfm <- dfm_short
      dfm_container$dfm_nterms <- nfeature(dfm_short)
      dfm_container$dfm_sparsity <- sparsity(dfm_short)
      dfm_container$dfm_documents <- ndoc(dfm_short)
    
    } else{
    
      shinyalert::shinyalert("Warning!","Your dfm is empty. You probably have removed too many words.", type = "warning")
      dfm_container$dfm_check <- FALSE
      dfm_container$dfm <- NULL
      dfm_container$dfm_nterms <- NULL
      dfm_container$dfm_sparsity <- NULL
      dfm_container$dfm_documents <- NULL
  
    }
    
    } else{
      
      shinyalert::shinyalert("Error!","No corpus exists. Have you uploaded a valid data set?", type = "error")
      dfm_container$dfm_check <- FALSE
      dfm_container$dfm <- NULL
      dfm_container$dfm_nterms <- NULL
      dfm_container$dfm_sparsity <- NULL
      dfm_container$dfm_documents <- NULL
      
    }

})

create_stopwords <- reactive({
  
  to_remove <- vector("character", 0)
  
  if(input$stopwords == "yes_stopwords") to_remove <- c(to_remove, stopwords(input$language))
  
  if(!is.null(input$stopword_csv_file)){
    
    inFile <- input$stopword_csv_file
    
    df <- data.table::fread(inFile$datapath, 
                            header = FALSE,
                            sep = "auto",
                            data.table = FALSE)[,1] 
    
    to_remove <- c(to_remove, df)
  }
  
  if(!is.null(input$stopwords_manual)){
    manual_words <- str_trim(unlist(strsplit(input$stopwords_manual, ",")))
    to_remove <- c(to_remove, manual_words)
  }
  
  if(!is.null(input$stopwords_keep)){
    stopwords_keep <- str_trim(unlist(strsplit(input$stopwords_keep, ",")))
    #to_remove <- to_remove[!(to_remove %in% stopwords_keep)]
    to_remove <- setdiff(to_remove, stopwords_keep)
  }
  
  to_remove 
})

output$n_docs <- renderValueBox({
  
  if(dfm_container$dfm_check){
    valueBox(dfm_container$dfm_documents, "Documents", icon = icon("list"), color = "aqua")
  } else{
    valueBox("-", "Documents", icon = icon("list"), color = "aqua") 
  }
  
})

output$sparse <- renderValueBox({
  
  if(dfm_container$dfm_check){
    valueBox(paste0(round(dfm_container$dfm_sparsity*100,2),"%"), "Sparsity", icon = icon("braille"), color = "purple")
  } else {
    valueBox("-", "Sparsity", icon = icon("braille"), color = "purple")
  }
  
})

output$n_terms <- renderValueBox({
  
  if(dfm_container$dfm_check){
    valueBox(dfm_container$dfm_nterms, "Features", icon = icon("text-height"), color = "green")
  } else {
    valueBox("-", "Features", icon = icon("text-height"), color = "green")
  }
  
})

###################### Output

# List of Stopwords

output$stopwordlist <- renderText({
  
  create_stopwords()
  
})

# Create Summary Plot from DFM

output$dfm_freq_plot <- renderPlot({
  
  validate(need(df_container$format_check, "The plot will be displayed here once you've uploaded your data and created the dfm."))
  validate(need(input$create_dfm & dfm_container$dfm_check, "The summary plot will be displayed here once you have created the dfm."))

  create_dfm_plot()
  
})  


############################################
# Download Plot 
############################################

create_dfm_plot <- reactive({
  
  corp <- corpus_container$corp
  dfm <- dfm_container$dfm
  
  if(input$dfm_group != ""){
    rank_features <- textstat_frequency(dfm, n = input$n_words_freq, 
                                        groups = docvars(corp, input$dfm_group))
  } else{
    rank_features <- textstat_frequency(dfm, n = input$n_words_freq)
  }
  
  if(input$type_of_dfm_plot == "dotplot"){
    
    selected_theme <- eval(parse(text = paste0("ggplot2::",input$dfm_theme,"(", base_size = input$dfm_font_size,")")))
    
    dfm_plot <-  rank_features %>%
      dplyr::filter(frequency >= input$min_freq_summary_plot) %>%
      ggplot(aes(x = nrow(rank_features):1, y = frequency)) +
      geom_point() +
      coord_flip() + 
      scale_x_continuous(breaks = nrow(rank_features):1,
                         labels = rank_features$feature) +
      labs(x = NULL, y = "Term frequency") +
      selected_theme
    
    if(input$dfm_group != "") dfm_plot <- dfm_plot + 
      facet_wrap(~ group, scales = "free")
  }
  
  if(input$type_of_dfm_plot == "wordcloud"){
    
    dfm_plot <- dfm %>%
      dfm_select(pattern = rank_features$feature) %>%
      textplot_wordcloud(min.freq = input$min_freq_summary_plot, 
                         random.order = FALSE,
                         rot.per = input$perc_rotating/100, 
                         colors = RColorBrewer::brewer.pal(8,"Dark2"))
  }
  
  dfm_plot
  
})

output$download_dfm_plot = downloadHandler(
  
  filename = function() { paste0("dfm_plot.", input$dfm_plot_device) },
  
  content = function(file) {
    
    ggsave(file, plot = create_dfm_plot(), device = input$dfm_plot_device, width = input$dfm_plot_width, height = input$dfm_plot_height, dpi = input$dfm_plot_res)
  
  }
)