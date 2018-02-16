#####################################################
#################### KEYNESS      ###################
#####################################################

## Note: This file subsets the dataframe (not the corpus object)

keyness_container <- reactiveValues(keyness = NULL,
                                    keyness_check = FALSE)

observeEvent(input$get_keyness, {
  
  if(dfm_container$dfm_check == FALSE){
    
    shinyalert::shinyalert("Error!",
                           "Keyness requires a dfm of a corpus. Please create a dfm first after having uploaded your corpus (see menu on the left).",
                           type = "error")

    keyness_container$keyness <- NULL
    keyness_container$keyness_check <- FALSE
    
  } else if(!(input$keyness_variable %in% colnames(docvars(corpus_container$corp)))){
    
    shinyalert::shinyalert("Error!",
                           "Keyness variable does not exist in your data.",
                           type = "error")
    
    keyness_container$keyness <- NULL
    keyness_container$keyness_check <- FALSE
    
    
  } else if(!(input$keyness_target %in% unique(docvars(corpus_container$corp, input$keyness_variable)))){
    
    shinyalert::shinyalert("Error!",
                           "Keyness target does not exist in your keyness variable.",
                           type = "error")
    
    keyness_container$keyness <- NULL
    keyness_container$keyness_check <- FALSE
    
  } else{
    
    withProgress(message = 'Estimating Keyness...', value = 0.5, {
      
      dfm <- dfm_container$dfm
      dfm_grouped <- dfm_group(dfm, groups = docvars(corpus_container$corp, input$keyness_variable))
      keyness_result <- textstat_keyness(dfm_grouped, target = input$keyness_target, measure = input$keyness_measure)
      keyness_container$keyness <- keyness_result
      keyness_container$keyness_check <- TRUE

    })
    
  }
})

output$keyness_plot <- renderPlot({
  
  validate(need(input$get_keyness, "The plot will be displayed here once you have estimated the Keyness model."))
  validate(need(dfm_container$dfm_check, "Please create a dfm."))
  validate(need(keyness_container$keyness_check, "Please estimate Keyness."))
  
  textplot_keyness(keyness_container$keyness, show_reference = input$keyness_ref == "show")
  
})