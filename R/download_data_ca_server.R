
##############################################
##############################################
# Download CA DATA
##############################################
##############################################

create_ca_data <- reactive({
  
  corp <- corpus_container$corp
  
  model <- ca_container$ca
  
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