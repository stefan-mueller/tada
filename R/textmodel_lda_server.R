
############################################
# LDA
############################################

# NOTE: This file runs the LDA/topicmodels

lda_container <- reactiveValues(lda = NULL,
                                lda_check = FALSE)

observeEvent(input$estimate_lda, {
  
  if(dfm_container$dfm_check == FALSE){
    shinyjs::alert("LDA requires a dfm of a corpus. Please create a dfm first after having uploaded your corpus (see menu on the left).")
    lda_container$lda <- NULL
    lda_container$lda_check <- FALSE
  } else {
  
  withProgress(message = 'Estimating LDA...', value = 0.5, {
    
    corp <- corpus_container$corp
    dfm <- dfm_container$dfm
    dfm <- convert(dfm, to = "topicmodels")
    
    lda <- try(LDA(dfm, 
               k = as.numeric(input$lda_topics), 
               method = "Gibbs", 
               control = list(verbose=25L, 
                              seed = input$lda_seed, 
                              burnin = as.numeric(input$lda_burnin), 
                              iter = as.numeric(input$lda_iter))))
    
    if(class(lda) != "try-error"){
      lda_container$lda <- lda
      lda_container$lda_check <- TRUE
    } else {
      shinyjs::alert(paste("An error occured while estimating LDA The error message is:", lda[1]))
      lda_container$lda <- NULL
      lda_container$lda_check <- FALSE 
    }
  })
  }
})

output$lda_topics <- renderDataTable({
  
  validate(need(df_container$format_check, "Please upload data before estimating LDA."))
  validate(need(dfm_container$dfm_check, "Please create a dfm before estimating LDA."))
  validate(need(lda_container$lda_check, "No LDA model has been estimated."))
  
  labels <- get_terms(lda_container$lda, input$lda_nlabel)
  
  labels_t <- data.frame("Topics" = colnames(labels), t(labels), stringsAsFactors = FALSE)
  
  colnames(labels_t) <- c("Topic", paste("Label", 1:input$lda_nlabel))
  
  return(labels_t)
  
})
