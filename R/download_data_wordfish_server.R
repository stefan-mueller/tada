
##############################################
##############################################
# Download WF DATA
##############################################
##############################################

# NOTE: This file downloads the wordfish plot(s)

create_wf_data <- reactive({
  
  corp <- corpus_container$corp
  
  model <- wf_container$wf
  
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