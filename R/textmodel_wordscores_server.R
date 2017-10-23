#####################################################
# Wordscores
#####################################################

# NOTE: This file runs the wordscores model 

ws_container <- reactiveValues(ws = NULL,
                               ws_check = FALSE,
                               ws_score_check = FALSE,
                               ws_pred = NULL)


observeEvent(input$estimate_ws, {
  
  if(dfm_container$dfm_check == FALSE){ 
    
    shinyjs::alert("Wordscores requires a dfm of a corpus. Please create a dfm first after having uploaded your corpus (see menu on the left).")
    ws_container$ws_score_check <- FALSE
    ws_container$ws <- NULL
    ws_container$ws_check <- FALSE  
    ws_container$ws_pred <- NULL
    
  } else {
  
    if(input$ws_scores %in% get_colnames()){
      
      ws_container$ws_score_check <- TRUE
    
    } else{
      
      shinyjs::alert("Scoring variable does not exist in your data! Please enter a valid scoring variable.")
      ws_container$ws_score_check <- FALSE
      ws_container$ws <- NULL
      ws_container$ws_check <- FALSE  
      ws_container$ws_pred <- NULL
      return(NULL)
    
    }
      
    withProgress(message = 'Estimating Wordscores...', value = 0.5, {
      
      corp <- corpus_container$corp
      dfm <- dfm_container$dfm
      scores <- docvars(corp, input$ws_scores)
      ws <- try(textmodel_wordscores(dfm, scores))
      
      if(class(ws) != "try-error"){
        
        ws_pred <- predict(ws, rescaling = input$ws_rescale, level = input$ws_ci/100)
        ws_container$ws <- ws
        ws_container$ws_pred <- ws_pred
        ws_container$ws_check <- TRUE
        
      } else{
        
        shinyjs::alert(paste("An error occured when estimating Wordscores The error message is:", ws[1]))
        ws_container$ws <- NULL
        ws_container$ws_check <- FALSE  
        ws_container$ws_pred <- NULL
        
      }
      
    })
    
  }

})

output$wordscores_summary <- renderDataTable({

  validate(need(df_container$format_check(), "The table will be displayed here once you've uploaded your data and estimated Wordscores."))
  validate(need(dfm_container$dfm_check, "The summary table will be displayed here once you have created the dfm."))
  validate(need(input$estimate_ws, "The results will be displayed here once you have estimated the Wordscores model."))
  validate(need(ws_container$ws_check, "The wordscores model couldn't be estimated."))
  
  summary(ws_container$ws)
  
})

output$wordscores_plot <- renderPlot({
  
  validate(need(df_container$format_check, "The table will be displayed here once you've uploaded your data and estimated Wordscores."))
  validate(need(dfm_container$dfm_check, "The summary table will be displayed here once you have created the dfm."))
  validate(need(input$estimate_ws, "The results will be displayed here once you have estimated the Wordscores model."))
  validate(need(ws_container$ws_check, "The wordscores model couldn't be estimated."))
  
  create_ws_plot()
  
})
