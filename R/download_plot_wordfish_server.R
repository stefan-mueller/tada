
##############################################
##############################################
# Download WORDFISH
##############################################
##############################################

# NOTE: This plot downloads the wordfish plot(s).

create_wf_plot <- reactive({
  
  corp <- corpus_container$corp
  
  source("R/textmodel_plot_server.R", local = TRUE)$value
  
  if(input$wf_plot_type == "documents"){
    if(input$wf_group == ""){
      plot_scaling_model(wf_container$wf, corp, 95)
    } else{
      plot_scaling_model(wf_container$wf, corp, 95, input$wf_group)
    }
  } else{
    textplot_scale1d(wf_container$wf, input$wf_plot_type)  
  }
  
})

output$download_wf_plot = downloadHandler(
  
  filename = function() { paste0("wf_plot.", input$wf_plot_device) },
  
  content = function(file) {
    ggsave(file, plot = create_wf_plot(), device = input$wf_plot_device, width = input$wf_plot_width, height = input$wf_plot_height, dpi = input$wf_plot_res)
  }
)