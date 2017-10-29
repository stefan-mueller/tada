fluidRow(
  
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_ca.Rmd")
  ),
  
  box(width = 8, title = "CA Options", collapsible = TRUE,
      numericInput("ca_dim", "Number of Dimensions", value = NA, min = 2, width = "10%"),
      actionButton("estimate_ca", h4(strong("Estimate CA")), width = "100%",
                   style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
  ),
  
  box(width = 4, title = "Download Results", collapsible = TRUE,
      splitLayout(#cellWidths = c("10%", "10%", "25%"),
        radioButtons("ca_include_meta", "Merge results with docvars", choices = list("Yes" = "TRUE", "No" = "FALSE"), inline = TRUE),
        radioButtons("ca_data_sep", "Delimiter for .csv data", choices = list(";" = ";", "," = ","), inline = TRUE)),
        downloadButton("download_ca_data", label = "Download Results (.csv)", width = "100%")
  ),
  
  #### Summary Plot
  
  box(width = 12, title = "CA Plot", collapsible = TRUE,
      column(width = 3,
             h4("Document Plot Suboptions"),
             numericInput("ca_dim_1", "X-Axis Dimension", min = 1, value = 1),
             numericInput("ca_dim_2", "Y-Axis Dimension", min = 1, value = 2),
             textInput("ca_group", "Grouping Variable", placeholder = "e.g., 'party'"),
             textInput("ca_xlab", "X-Axis Label", placeholder = "e.g., 'Dimension 1'"),
             textInput("ca_ylab", "Y-Axis Label", placeholder = "e.g., 'Dimension 2'"),
             textInput("ca_title", "Plot Title", placeholder = "e.g., 'CA results'"),
             checkboxInput("ca_show_legend", "Show Legend", value = FALSE),
             conditionalPanel(
               condition = "input.ca_show_legend == true",
               radioButtons("ca_legend_position", "Legend Position", 
                            choices = list("Bottom" = "bottom", 
                                           "Top" = "top",
                                           "Left" = "left",
                                           "Right" = "right"), inline = TRUE),
               textInput("ca_legend_title", "Legend Title", value = "Grouping")
             ),
             radioButtons("ca_position_plot_type", "Type of Document Plot", 
                          choices = list("Point Estimates" = "point", 
                                         "Stacked Density" = "joy", 
                                         "Boxplot" = "boxplot"), 
                          inline = TRUE),
             radioButtons("ca_theme", "Plotting Theme", 
                          choices = list("Default" = "theme_grey", 
                                         "Black & White" = "theme_bw",
                                         "Classic" = "theme_classic",
                                         "Minimal" = "theme_minimal",
                                         "Void" = "theme_void"), inline = TRUE),
             sliderInput("ca_font_size", "Font Size", min = 8, max = 20, step = 1, value = 12),
             sliderInput("ca_transparency", "Transparency", min = 0.05, max = 1, step = 0.05, value = .5)
      ),
      column(width = 9,
             plotOutput("ca_plot", height = "800px")),
      column(width = 12,
             hr(),
             h4("Download Plot Options"),
             splitLayout(
               radioButtons("ca_plot_device", "File Format", 
                            choices = list("pdf" = "pdf", 
                                           "png" = "png"),
                            inline = TRUE),
               numericInput("ca_plot_res", "dpi", min = 72, max = 666, value = 300, width = "75%"),
               numericInput("ca_plot_width", "Width (in)", min = 1, max = 100, value = 4, width = "75%"),
               numericInput("ca_plot_height", "Height (in)", min = 1, max = 100, value = 8, width = "75%"),
               downloadButton("download_ca_plot", label = "Download Plot")
             )
      )
  ),
  
  #### Summary Data
  
  box(width = 12, title = "CA Summary", collapsible = TRUE, collapsed = TRUE,
      dataTableOutput("ca_summary")
  )
)