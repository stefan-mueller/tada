# Wordscores

fluidRow(
  
  # Help
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_wordscores.Rmd")
  ),
  
  box(width = 8, title = "Wordscores Options", collapsible = TRUE,
      splitLayout(cellWidths = rep("25%",4),
                  textInput("ws_scores", "Name of Scoring Variable", placeholder = "e.g., 'ref_scores'", width = "75%"),
                  radioButtons("ws_rescale", "Type of Rescaling", choices = list("Raw" = "none", "LBG" = "lbg", "MV" = "mv"), inline = TRUE),
                  sliderInput("ws_ci", "Confidence Intervals (%)", min = 80, max = 99, step = 1, value = 95, width = "75%")),
      actionButton("estimate_ws", h4(strong("Estimate Wordscores")), width = "100%",
                   style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
  ),
  
  box(width = 4, title = "Download Results", collapsible = TRUE,
      splitLayout(#cellWidths = c("10%", "10%", "25%"),
        radioButtons("ws_include_meta", "Merge results with docvars", choices = list("Yes" = "TRUE", "No" = "FALSE"), inline = TRUE),
        radioButtons("ws_data_sep", "Delimiter for .csv data", choices = list(";" = ";", "," = ","), inline = TRUE)),
      downloadButton("download_ws_data", label = "Download Results (.csv)", width = "100%")
  ),
  
  infoBoxOutput(width = 12, "info_score_var"),
  
  #### Summary Plot
  
  box(width = 12, title = "Wordscores Plot", collapsible = TRUE,
      column(width = 3,
             radioButtons("ws_plot_type", "Type of result plot", choices = list("Documents" = "documents", "Features" = "features"), inline = TRUE),
             hr(),
             h4("Document Plot Suboptions"),
             radioButtons("ws_exclude_ref", "Exclude reference text positions from plot", choices = list("Yes" = TRUE, "No" = FALSE), selected = FALSE, inline = TRUE),
             textInput("ws_group", "Grouping Variable", placeholder = "e.g., 'party'"),
             textInput("ws_xlab", "X-Axis Label", value = "Position"),
             textInput("ws_ylab", "Y-Axis Label", value = "Document"),
             textInput("ws_title", "Plot Title", placeholder = "e.g., 'Wordscores results'"),
             checkboxInput("ws_show_legend", "Show Legend", value = FALSE),
             conditionalPanel(
               condition = "input.ws_show_legend == true",
               radioButtons("ws_legend_position", "Legend Position", 
                            choices = list("Bottom" = "bottom", 
                                           "Top" = "top",
                                           "Left" = "left",
                                           "Right" = "right"), inline = TRUE),
               textInput("ws_legend_title", "Legend Title", value = "Grouping")
             ),
             radioButtons("ws_position_plot_type", "Type of Document Plot", 
                          choices = list("Point Estimates" = "point", 
                                         "Stacked Density" = "joy", 
                                         "Boxplot" = "boxplot"), 
                          inline = TRUE),
             radioButtons("ws_theme", "Plotting Theme", 
                          choices = list("Default" = "theme_grey", 
                                         "Black & White" = "theme_bw",
                                         "Classic" = "theme_classic",
                                         "Minimal" = "theme_minimal",
                                         "Void" = "theme_void"), inline = TRUE),
             sliderInput("ws_font_size", "Font Size", min = 8, max = 20, step = 1, value = 16),
             sliderInput("ws_transparency", "Transparency", min = 0.05, max = 1, step = 0.05, value = .5)
      ),
      column(width = 9,
             plotOutput("wordscores_plot", height = "800px")
             ),
      column(width = 12,
             hr(),
             h4("Download Plot Options"),
             splitLayout(
               radioButtons("ws_plot_device", "File Format", 
                            choices = list("pdf" = "pdf", 
                                           "png" = "png"),
                            inline = TRUE),
               numericInput("ws_plot_res", "dpi", min = 72, max = 666, value = 300, width = "75%"),
               numericInput("ws_plot_width", "Width (in)", min = 1, max = 100, value = 7, width = "75%"),
               numericInput("ws_plot_height", "Height (in)", min = 1, max = 100, value = 5, width = "75%"),
               downloadButton("download_ws_plot", label = "Download Plot")
             ))
  ),
  
  #### Data Summaty
  
  box(width = 12, title = "Wordscores Summary", collapsible = TRUE, collapsed = TRUE,
      dataTableOutput("wordscores_summary")
  )
)