#####################################################
#################### Upload Functions  ##############
#####################################################

read_data <- eventReactive(!is.null(input$upload_file) | input$use_default == TRUE, { 
  
  if(!input$use_default){
  inFile <- input$uploaded_file
  
  extension <- tools::file_ext(inFile$name)
  
  if(extension == "dta") df <- read_external_shiny() else if(extension == "sav") df <- read_external_shiny() else if(extension == "xlsx") df <- read_xlsx_shiny() else if(extension == "csv") df <- read_csv_shiny() else if(extension == "rds") df <- read_rds_shiny()
  
  } else{
    #df <- data.table::fread("sample_data/data_manifestos_uk_2015.csv", data.table = F, stringsAsFactors = F)
    df <- as.data.frame(readRDS(file = "sample_data/manifestos_ireland_1990_2016.Rds"))
  }
  
  df
})

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
  
  as.data.frame(read_excel(paste(inFile$datapath, extension, sep="."), 1))
  
})

read_external_shiny <- reactive({
  
  inFile <- input$uploaded_file
  
  ext <- tools::file_ext(inFile$name)
  
  if(ext == "dta") df <- as.data.frame(read_dta(inFile$datapath))
  if(ext == "sav") df <- as.data.frame(read_sav(inFile$datapath)) #as.data.frame(read_sav(inFile$datapath))
  
  df
})

read_rds_shiny <- reactive({
  
  inFile <- input$uploaded_file
  
  readRDS(inFile$datapath)
  
})

#####################################################
#################### Subset Data  ###################
#####################################################

# This might be better than corpus_subset ...so the workflow is:
# 1. Upload Data (Frame one)
# 1.1 Check if everything was read in correctly (numeric / character etc)
# 1.2 Subset Data if Necessary
# 2. Create and Inspect Corpus (Frame 2)
# 3. Analyze Corpus (Frames 3 - ...)

# What do you think???


subset_data <- reactive({
  
  if(input$subset_condition != ""){
    df <- subset(read_data(), eval(parse(text = input$subset_condition)))
  } else{
    df <- read_data()
  }
  
  df
  
})


################################################################
#################### Helper Functions Upload Page ##############
################################################################

get_colnames <- reactive({
  
  cnames <- colnames(subset_data())
  
  cnames
})

get_coltypes <- reactive({
  
  col_names <- get_colnames()
  
  types <- sapply(subset_data(), class)
  
  data.frame("Variable" = col_names, "Type" = types, stringsAsFactors = F)
  
})

guess_textvar <- reactive({
  
  if(!input$use_default){ # wenn kein default data genutzt wird...
    if(input$text_var != ""){ # wenn text variable angegeben wird!
      text_var <- input$text_var
    } else { # wenn keine text variable angegeben wird: suche char-spalte mit den meisten buchstaben
      df <- subset_data()
      char_vars <- sapply(df, is.character) # get only char vars
      rows <- nrow(df) # number of rows
      if(rows > 10) rows <- 10 # if more than 10 rows, then only use top ten (more efficient)
      text_length <- apply(df[1:rows, char_vars], 2, function(x) sum(nchar(x))) # sum of chars in all char-vars for first ten obs
      text_var <- names(text_length)[text_length==max(text_length)] # get var max
      if(length(text_var) > 1) text_var <- text_var[1] # in case of identical lengths (very unlikely!!!)
    }
  } else{
    text_var <- "text"
  }
  text_var  
})

check_textfiled <- reactive({
  
  check <- guess_textvar() %in% get_colnames()
  
  check
})

create_infobox <- reactive({
  if(!input$use_default) {
    if(is.null(input$uploaded_file$name)){info_text <- paste0("Please upload your data or use the default text corpus."); color_text = "orange"}
    if(!is.null(input$uploaded_file$name)){
      if(input$text_var == ""){info_text <- paste0("The text variable will be chosen automatically. Use the menu on the top right to change the variable."); color_text = "orange"}
      if(input$text_var != "" & check_textfiled()){info_text <- paste0("You have chosen the variable '", input$text_var, "' as your text variable. Use the menu on the top right to change the variable."); color_text = "green"}
      if(input$text_var != "" & !check_textfiled()) {info_text <- paste0("Attention: The variable '", input$text_var, "' does not exist in your data! Please prove a valid variable name using the menu on the top-right"); color_text = "red"}
    }
  } else if(input$use_default){
    info_text <- paste0("You are now using the Irish Manifesto Corpus. This dataset contains the  manifestos from the main Irish political parties for all elections between 1990 and 2016. Text and Document ID variables were chosen automatically."); color_text = "blue"
  }

  c(info_text, color_text)
})

############# Output

# Table with coltypes

output$report_coltypes <- renderDataTable({
  
  validate(need(input$upload_file | input$use_default == TRUE, "The table will be displayed here once you've uploaded your data."))
  validate(need(check_textfiled(), "Attention: Table cannot be displayed because the textfield variable that you entered does not exist in your data. Please provide a valid name for oyur text variable."))
  
  get_coltypes()
  
})

# Full Data Output

output$full_data <- renderDataTable({
  
  validate(need(input$upload_file | input$use_default == TRUE, "The table will be displayed here once you've uploaded your data."))
  validate(need(check_textfiled(), "Attention: Table cannot be displayed because the textfield variable that you entered does not exist in your data. Please provide a valid name for oyur text variable."))
  
  dplyr::select(subset_data(), -eval(parse(text = guess_textvar())))
  
})

# Create Infobox

output$info_text <- renderInfoBox({
  info_box_info <- create_infobox()
  infoBox(value = info_box_info[1], title = "text variable", color = info_box_info[2], icon = icon("file-text"))
}) 

#####################################################
#################### Corpus Page ####################
#####################################################

create_corpus <- reactive({
  
  if(!input$use_default){
  corp <- corpus(subset_data(), text_field = guess_textvar(), docid_field = input$doc_var)
  } else {
  corp <- corpus(subset_data(), text_field = guess_textvar(), docid_field = "doc_id")
  }
  if(input$reshape_corpus != "documents") corp <- corpus_reshape(corp, to = input$reshape_corpus)
  
  corp
})

create_summary_table <- reactive({
  
  corp <- create_corpus()
  
  sum_corp <- summary(corp, n = 999999, verbose = FALSE, showmeta = TRUE)
  
  sum_corp
})

create_short_summary_table <- reactive({
  
  corp <- create_corpus()
  
  sum_corp <- summary(corp, n = 999999, verbose = FALSE, showmeta = TRUE)
  
  n_vars <- ncol(docvars(corp))
  n_docs <- ndoc(corp)
  tokens <- mean(sum_corp$Tokens, na.rm = TRUE)
  sentences <- mean(sum_corp$Sentences, na.rm = TRUE)
  
  df <- data.frame(Information = c("Number of variables", "Number of documents", "Average number of tokens","Average number of sentences"), 
                   N = c(n_vars,n_docs, tokens, sentences), stringsAsFactors = FALSE)
  
  df
})


get_display_text <- eventReactive(input$get_display_text, {
  
  corp <- create_corpus()
  
  all_docs <- texts(corp)
  
  text_id <- input$text_selector
  
  if(text_id == "") text_id <- 1
  if(!is.na(as.numeric(text_id))) text_id <- as.numeric(text_id)
  
  all_docs[text_id]
  
})

################## Output

output$display_text <- renderText({
  
  get_display_text()
  
})

output$short_summary_table <- renderTable({
  
  validate(need(input$upload_file | input$use_default == TRUE, "The table will be displayed here once you've uploaded your data."))
  validate(need(check_textfiled(), "Attention: Table cannot be displayed because the textfield variable that you entered does not exist in your data. Please provide a valid name for oyur text variable."))
  
  create_short_summary_table()
  
}, width = "100%")

output$summary_table <- renderDataTable({
  
  validate(need(input$upload_file  | input$use_default == TRUE, "The table will be displayed here once you've uploaded your data."))
  validate(need(check_textfiled(), "Attention: Table cannot be displayed because the textfield variable that you entered does not exist in your data. Please provide a valid name for oyur text variable."))
  
  create_summary_table()
  
})


#####################################################
#################### Functions DFM ##################
#####################################################  

create_dfm <- eventReactive(input$create_dfm, {
  
  withProgress(message = 'Creating dfm...', value = 0, {
    
  corp <- create_corpus()
  
  incProgress(0.1, detail = "Remove Terms and Stem...")
  
  dfm_raw <- dfm(corp, tolower = input$lowercase == "TRUE", 
      stem = input$stemming == "FALSE",
      remove_punct = input$punctuation == "TRUE",
      remove_twitter = input$twitter == "FALSE",
      remove_numbers = input$numbers == "FALSE",
      remove_symbols = input$symbols == "FALSE",
      remove_hyphens = input$hyphens == "FALSE",
      remove_url = input$url == "FALSE",
      remove_separators = input$separators == "FALSE",
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
  
  dfm_short
})

create_stopwords <- reactive({
  
  to_remove <- ""
  
  if(input$stopwords == "TRUE") to_remove <- c(to_remove, stopwords(input$language))
  
  if(!is.null(input$stopword_csv_file)){
    
  inFile <- input$stopword_csv_file
    
  df <- data.table::fread(inFile$datapath, 
                      header = FALSE,
                      sep = "auto",
                      data.table = FALSE)[,1] 
    
  to_remove <- c(to_remove,df)
  }
  
  if(!is.null(input$stopwords_manual)){
    manual_words <- str_trim(unlist(strsplit(input$stopwords_manual, ",")))
    to_remove <- c(to_remove, manual_words)
  }
 
  if(!is.null(input$stopwords_keep)){
    stopwords_keep <- str_trim(unlist(strsplit(input$stopwords_keep, ",")))
    to_remove <- to_remove[!(to_remove %in% stopwords_keep)]
  }
  
  to_remove 
})

###################### Output

# List of Stopwords

output$stopwordlist <- renderText({
  
  create_stopwords()
  
})

# Create Summary Plot from DFM

output$dfm_freq_plot <- renderPlot({
  
  validate(need(input$create_dfm, "The summary plot will be displayed here once you have created the dfm."))
  
  corp <- create_corpus()
  
  validate(need(is.corpus(corp), "Attention: dfm couldn't be created. Please check the data."))
  
  dfm <- create_dfm()
  
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

###############################################
# Wordfish
###############################################
  
wf_model <- eventReactive(input$estimate_wf, {
  
  withProgress(message = 'Estimating Wordfish...', value = 0.5, {
  dfm <- create_dfm()
  dir <- as.numeric(c(input$wf_dir1, input$wf_dir2))
  wf <- textmodel_wordfish(dfm)
  })
  wf

})  

################### output

output$wordfish_plot <- renderPlot({
  
    validate(need(input$estimate_wf, "The plot will be displayed here once you have estimated the Wordfish model."))
  
    corp <- create_corpus()
    
    source("model_plot.R", local = TRUE)$value
    
    if(input$wf_plot_type == "documents"){
      if(input$wf_group == ""){
        #textplot_scale1d(wf_model(), input$wf_plot_type)
        plot_scaling_model(wf_model(), corp, 95)
      } else{
        plot_scaling_model(wf_model(), corp, 95, input$wf_group)
        #textplot_scale1d(wf_model(), input$wf_plot_type, groups = docvars(corp, input$wf_group))
      }
    } else{
      textplot_scale1d(wf_model(), input$wf_plot_type)  
    }
    
})

output$wordfish_summary <- renderDataTable({
  
  wf <- wf_model()
  
  sum_wf <- summary(wf)
  
  sum_wf <- data.frame(document = rownames(sum_wf), sum_wf, stringsAsFactors = F)
  
  sum_wf <- sum_wf[rev(order(sum_wf$theta)),]

  sum_wf
})

#####################################################
# KWIC
#####################################################

get_kwic_table <- eventReactive(input$get_kwic, {
  
  withProgress(message = 'Finding Keywords...', value = 0.5, {
    
  corp <- create_corpus()
  
  kwic_tab <- kwic(corp, pattern = input$kwic_word, window = input$kwic_window, case_insensitive = input$kwic_ignore_case == "TRUE")
  })
  
  kwic_tab
})
  
output$kwic_table <- renderDataTable({
  
  get_kwic_table()
  
})  
  
#####################################################
# Wordscores
#####################################################

#######
# Score Var Checks
#######

check_score_var <- eventReactive(input$estimate_ws, {
  
  check <- input$ws_scores %in% get_colnames()
  
  check
})

create_score_infobox <- eventReactive(input$estimate_ws, {
  
  if(input$ws_scores == ""){
    info_text <- paste0("Please enter the name of the scoring variable.")
    color_text <- "red"
  } else if(input$ws_scores != "" & !check_score_var()){
      info_text <- paste0("The scoring variable does not exist in your data.")
      color_text <- "red"
  } else{
    info_text <- paste0("There are ", sum(is.na(subset_data()[input$ws_scores]))," virgin texts in your data.")
    color_text <- "green"
  }
  
  return(c(info_text, color_text))
  
})  

# Create Infobox

output$info_score_var <- renderInfoBox({
  info_box_info <- create_score_infobox()
  infoBox(value = info_box_info[1], title = "scoring variable", color = info_box_info[2], icon = icon("file-text"))
})  

#######
# Fit Wordscores
#######

run_ws <- eventReactive(input$estimate_ws, {
  
  withProgress(message = 'Estimating Wordscores...', value = 0.5, {
    
  if(check_score_var()){
    
  corp <- create_corpus()
  
  dfm <- create_dfm()
  
  scores <- docvars(corp, input$ws_scores)
    
  raw_ws <- textmodel_wordscores(dfm, scores)
  
  return(raw_ws)
  
  }
  })
})

predict_ws <- reactive({
  
  withProgress(message = 'Predicting Wordscores...', value = 0.5, {
    
  pred_ws <- predict(run_ws(), rescaling = input$ws_rescale, level = input$ws_ci/100)
  
  })
  
  pred_ws
})

output$wordscores_summary <- renderDataTable({
  
  summary(run_ws())
  
})

output$wordscores_plot <- renderPlot({
  
  validate(need(input$estimate_ws, "The plot will be displayed here once you have estimated the Wordscores model."))
  
  corp <- create_corpus()
  
  source("model_plot.R", local = TRUE)$value
  
  if(input$ws_plot_type == "documents"){
    if(input$ws_group == ""){
      plot_scaling_model(run_ws(), corp, 95, ws_pred = predict_ws())
    } else{
      plot_scaling_model(run_ws(), corp, 95, input$ws_group, ws_pred = predict_ws())
    }
  } else{
    textplot_scale1d(predict_ws(), input$ws_plot_type)  
  }
  
})

############################################
# LDA
############################################

run_lda <- eventReactive(input$estimate_lda, {
  
  withProgress(message = 'Estimating LDA...', value = 0.5, {
    
  corp <- create_corpus()
  dfm <- create_dfm()
  dfm <- convert(dfm, to = "topicmodels")
  
  lda <- LDA(dfm, 
      k = as.numeric(input$lda_topics), 
      method = "Gibbs", 
      control = list(verbose=25L, 
                     seed = input$lda_seed, 
                     burnin = as.numeric(input$lda_burnin), 
                     iter = as.numeric(input$lda_iter)))
  })
  
  lda
})

output$lda_topics <- renderDataTable({
  
  return(get_terms(run_lda(), input$lda_nlabel))
  
})

##############################################
##############################################
# Download WF DATA
##############################################
##############################################

create_wf_data <- reactive({
  
  corp <- create_corpus()
  
  model <- wf_model()
  
  position_df <- data.frame(docs = model@docs,
                            theta = model@theta, 
                            theta_se = model@se.theta,
                            stringsAsFactors = F)
  
  if(input$wf_include_meta == "TRUE") position_df <- merge(position_df, docvars(corp), by.x = "docs", by.y = "row.names", all.x = TRUE)

  position_df
  
})

output$download_wf_data = downloadHandler(
  
  filename = function() { paste0("wf_data.csv") },
  
  content = function(file) {
    write.table(create_wf_data(), file, sep = input$wf_data_sep, na = "", row.names = FALSE)
  }
)


##############################################
##############################################
# Downloads: WORDFISH
##############################################
##############################################

create_wf_plot <- reactive({
  
  corp <- create_corpus()
  
  source("model_plot.R", local = TRUE)$value
  
  if(input$wf_plot_type == "documents"){
    if(input$wf_group == ""){
      #textplot_scale1d(wf_model(), input$wf_plot_type)
      plot_scaling_model(wf_model(), corp, 95)
    } else{
      plot_scaling_model(wf_model(), corp, 95, input$wf_group)
      #textplot_scale1d(wf_model(), input$wf_plot_type, groups = docvars(corp, input$wf_group))
    }
  } else{
    textplot_scale1d(wf_model(), input$wf_plot_type)  
  }
  
})

output$download_wf_plot = downloadHandler(
  
  filename = function() { paste0("wf_plot.", input$wf_plot_device) },
  
  content = function(file) {
    ggsave(file, plot = create_wf_plot(), device = input$wf_plot_device, width = input$wf_plot_width, height = input$wf_plot_height, dpi = input$wf_plot_res)
  }
)

##############################################
##############################################
# Downloads: WORDSCORES
##############################################
##############################################

create_ws_plot <- reactive({
  
  corp <- create_corpus()
  
  source("model_plot.R", local = TRUE)$value
  
  if(input$ws_plot_type == "documents"){
    if(input$ws_group == ""){
      plot_scaling_model(run_ws(), corp, 95, ws_pred = predict_ws())
    } else{
      plot_scaling_model(run_ws(), corp, 95, input$ws_group, ws_pred = predict_ws())
    }
  } else{
    textplot_scale1d(predict_ws(), input$ws_plot_type)  
  }
  
})

output$download_ws_plot = downloadHandler(
  
  filename = function() { paste0("ws_plot.", input$ws_plot_device) },
  
  content = function(file) {
    ggsave(file, plot = create_ws_plot(), device = input$ws_plot_device, width = input$ws_plot_width, height = input$ws_plot_height, dpi = input$ws_plot_res)
  }
)


###############################################
# CA
###############################################

ca_model <- eventReactive(input$estimate_ca, {
  
  withProgress(message = 'Estimating CA...', value = 0.5, {
    
  dfm <- create_dfm()
  ca <- textmodel_ca(dfm, nd = input$ca_dim)
  })
  
  ca
  
})  

################### output

output$ca_plot <- renderPlot({
  
  validate(need(input$estimate_ca, "The plot will be displayed here once you have estimated the CA model."))
  
  corp <- create_corpus()
  
  source("model_plot.R", local = TRUE)$value
  
    if(input$ca_group == ""){
      plot_scaling_model(ca_model(), corp, 95)
    } else{
      plot_scaling_model(ca_model(), corp, 95, input$ca_group)
    }
  
})

output$ca_summary <- renderDataTable({
  
  ca <- ca_model()
  
  sum_ca <- ca$rowcoord

  sum_ca <- data.frame(document = rownames(sum_ca), sum_ca, stringsAsFactors = F)
  
  sum_ca <- sum_ca[rev(order(sum_ca$Dim1)),]
  
  sum_ca
})

##############################################
##############################################
# Downloads: CA
##############################################
##############################################

create_ca_plot <- reactive({
  
  corp <- create_corpus()
  
  source("model_plot.R", local = TRUE)$value
  
  if(input$ca_group == ""){
    plot_scaling_model(ca_model(), corp, 95)
  } else{
    plot_scaling_model(ca_model(), corp, 95, input$ca_group)
  }
  
})

output$download_ca_plot = downloadHandler(
  
  filename = function() { paste0("ca_plot.", input$ca_plot_device) },
  
  content = function(file) {
    ggsave(file, plot = create_ca_plot(), device = input$ca_plot_device, width = input$ca_plot_width, height = input$ca_plot_height, dpi = input$ca_plot_res)
  }
)

##############################################
##############################################
# Download WS DATA
##############################################
##############################################

create_ws_data <- reactive({
  
  corp <- create_corpus()
  
  ws_pred <- predict_ws()
  
  rescale <- ifelse(input$ws_rescale == "none", "raw", input$ws_rescale)
  
  position_df <- data.frame(theta = ws_pred@textscores[,paste0("textscore_",rescale)], 
                            llci = ws_pred@textscores[,paste0("textscore_",rescale,"_lo")],
                            ulci = ws_pred@textscores[,paste0("textscore_",rescale,"_hi")],
                            docs = rownames(ws_pred@textscores), stringsAsFactors = F)
  
  if(input$ws_include_meta == "TRUE") position_df <- merge(position_df, docvars(corp), by.x = "docs", by.y = "row.names", all.x = TRUE)
  
  position_df
  
})

output$download_ws_data = downloadHandler(
  
  filename = function() { paste0("ws_data.csv") },
  
  content = function(file) {
    write.table(create_ws_data(), file, sep = input$ws_data_sep, na = "", row.names = FALSE)
  }
)

##############################################
##############################################
# Download CA DATA
##############################################
##############################################

create_ca_data <- reactive({
  
  corp <- create_corpus()
  
  model <- ca_model()
  
  position_df <- data.frame(docs = rownames(model$rowcoord),
                            model$rowcoord, 
                            stringsAsFactors = F)
  
  if(input$ca_include_meta == "TRUE") position_df <- merge(position_df, docvars(corp), by.x = "docs", by.y = "row.names", all.x = TRUE)
  
  position_df
  
})

output$download_ca_data = downloadHandler(
  
  filename = function() { paste0("ca_data.csv") },
  
  content = function(file) {
    write.table(create_ca_data(), file, sep = input$ca_data_sep, na = "", row.names = FALSE)
  }
)