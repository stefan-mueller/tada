
#####################################################
# KWIC
#####################################################

# NOTE: This file allows to look up keywords in context

observe({
  
  if (is.null(input$kwic_word) || input$kwic_word == "") {
    shinyjs::disable("get_kwic")
  } else {
    shinyjs::enable("get_kwic")
  }
  
})

get_kwic_table <- eventReactive(input$get_kwic, {
  
  withProgress(message = 'Finding Keywords...', value = 0.5, {
    
    corp <- corpus_container$corp
    
    kwic_tab <- kwic(corp, pattern = input$kwic_word, window = input$kwic_window, case_insensitive = input$kwic_ignore_case == "TRUE")
  })
  
  kwic_tab
})

output$kwic_table <- renderDataTable({
  
  validate(need(df_container$upload_check, "No data uploaded."))
  validate(need(df_container$format_check, "No data uploaded."))
  validate(need(corpus_container$corpus_check, "No valid corpus."))
  validate(need(input$kwic_word != "", "Please enter a keyword."))
  validate(need(input$get_kwic, "Please click on the 'Start KWIC Analysis'-Button."))
  
  get_kwic_table()
  
})

##############################################
##############################################
# Download KWIC DATA
##############################################
##############################################

output$download_kwic_data = downloadHandler(
  
  filename = function() { paste0("kwic_data.csv") },
  
  content = function(file) {
    write.table(get_kwic_table(), file, sep = input$kwic_data_sep, na = "", row.names = FALSE)
  }
)