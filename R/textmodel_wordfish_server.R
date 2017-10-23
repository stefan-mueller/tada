
###############################################
# Wordfish
###############################################

# NOTE: This file runs the wordfish model.

wf_container <- reactiveValues(wf = NULL,
                               wf_check = FALSE)

observeEvent(input$estimate_wf, {
  
  if(dfm_container$dfm_check == FALSE){
    
    shinyjs::alert("Wordfish requires a dfm of a corpus. Please create a dfm first after having uploaded your corpus (see menu on the left).")
    wf_container$wf <- NULL
    wf_container$wf_check <- FALSE
    
  } else{
  
  withProgress(message = 'Estimating Wordfish...', value = 0.5, {
    dfm <- dfm_container$dfm
    dir <- as.numeric(c(input$wf_dir1, input$wf_dir2))
    wf <- try(textmodel_wordfish(dfm))
  })

  if(class(wf) != "try-error"){
    
    wf_container$wf <- wf
    wf_container$wf_check <- TRUE
    
  } else{
    
    shinyjs::alert(paste("An error occured when estimating Wordfish. The error message is:", wf[1]))
    wf_container$wf <- NULL
    wf_container$wf_check <- FALSE    
  
  }
  }
})  

################### output

output$wordfish_plot <- renderPlot({
  
  validate(need(input$estimate_wf, "The plot will be displayed here once you have estimated the Wordfish model."))
  validate(need(dfm_container$dfm_check, "Please create a dfm."))
  validate(need(wf_container$wf_check, "Please estimate Wordfish."))
  
  create_wf_plot()
  
})

output$wordfish_summary <- renderDataTable({
  
  wf <- wf_container$wf
  
  sum_wf <- summary(wf)
  
  sum_wf <- data.frame(document = rownames(sum_wf), sum_wf, stringsAsFactors = F)
  
  sum_wf <- sum_wf[rev(order(sum_wf$theta)),]
  
  sum_wf
})