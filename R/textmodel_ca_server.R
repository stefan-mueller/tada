###############################################
# CA
###############################################

# NOTE: This file runs a Correspondence Analysis

ca_container <- reactiveValues(ca = NULL,
                               ca_check = FALSE)

observeEvent(input$estimate_ca, {

  if(dfm_container$dfm_check == FALSE){
    
    shinyjs::alert("CA requires a dfm of a corpus. Please create a dfm first after having uploaded your corpus (see menu on the left).")
    ca_container$ca <- NULL
    ca_container$ca_check <- FALSE
  
  } else{
  
    withProgress(message = 'Estimating CA...', value = 0.5, {
    dfm <- dfm_container$dfm
    ca <- try(textmodel_ca(dfm, nd = input$ca_dim))
    
    if(class(ca) != "try-error"){
      
      ca_container$ca <- ca
      ca_container$ca_check <- TRUE
      
    } else{
      
      shinyjs::alert(paste("An error occured when estimating CA The error message is:", ca[1]))
      ca_container$ca <- NULL
      ca_container$ca_check <- FALSE    
      
    }
    })
    
  }
  
})  

################### output

output$ca_plot <- renderPlot({
  
  validate(need(input$estimate_ca, "The plot will be displayed here once you have estimated the CA model."))
  validate(need(dfm_container$dfm_check, "Please create a dfm."))
  validate(need(ca_container$ca_check, "The plot will be displayed here once you have estimated the CA model."))
  
  create_ca_plot()
  
})

output$ca_summary <- renderDataTable({
  
  ca <- ca_container$ca
  
  sum_ca <- ca$rowcoord
  
  sum_ca <- data.frame(document = rownames(sum_ca), sum_ca, stringsAsFactors = F)
  
  sum_ca <- sum_ca[rev(order(sum_ca$Dim1)),]
  
  sum_ca
})
