
##############################################
##############################################
# Download WS DATA
##############################################
##############################################

create_ws_data <- reactive({
  
  corp <- corpus_container$corp
  
  ws_pred <- ws_container$ws_pred
  
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