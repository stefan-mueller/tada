
##############################################
##############################################
# Downloads: WORDSCORES
##############################################
##############################################

create_ws_plot <- reactive({
  
  corp <- corpus_container$corp
  
  source("R/textmodel_plot_server.R", local = TRUE)$value
  
  if(input$ws_plot_type == "documents"){
    if(input$ws_group == ""){
      plot_scaling_model(ws_container$ws, corp, 95, ws_pred = ws_container$ws_pred)
    } else{
      plot_scaling_model(ws_container$ws, corp, 95, input$ws_group, ws_pred = ws_container$ws_pred)
    }
  } else{
    textplot_scale1d(ws_container$ws_pred, input$ws_plot_type)  
  }
  
})

output$download_ws_plot = downloadHandler(
  
  filename = function() { paste0("ws_plot.", input$ws_plot_device) },
  
  content = function(file) {
    ggsave(file, plot = create_ws_plot(), device = input$ws_plot_device, width = input$ws_plot_width, height = input$ws_plot_height, dpi = input$ws_plot_res)
  }
)
