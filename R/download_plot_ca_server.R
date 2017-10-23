
##############################################
##############################################
# Downloads: CA
##############################################
##############################################

# NOTE: This file downloads the CA plot

create_ca_plot <- reactive({
  
  corp <- corpus_container$corp
  
  source("R/textmodel_plot_server.R", local = TRUE)$value
  
  if(input$ca_group == ""){
    plot_scaling_model(ca_container$ca, corp, 95)
  } else{
    plot_scaling_model(ca_container$ca, corp, 95, input$ca_group)
  }
  
})

output$download_ca_plot = downloadHandler(
  
  filename = function() { paste0("ca_plot.", input$ca_plot_device) },
  
  content = function(file) {
    ggsave(file, plot = create_ca_plot(), device = input$ca_plot_device, width = input$ca_plot_width, height = input$ca_plot_height, dpi = input$ca_plot_res)
  }
)
