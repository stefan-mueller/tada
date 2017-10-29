fluidRow(
  
  # Help
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_wordfish.Rmd")
  ),
  
  box(width = 8, title = "Wordfish Options", collapsible = TRUE,
      splitLayout(#cellWidths = c("10%", "10%", "25%"),
      numericInput("wf_dir1", "Left anchor", value = 1, width = "75%"),
      numericInput("wf_dir2", "Right anchor", value = 2, width = "75%"),
      sliderInput("wf_ci", "Confidence Intervals", min = 80, max = 99, step = 1, value = 95, width = "75%")),
      actionButton("estimate_wf", h4(strong("Estimate Wordfish")), width = "100%",
                   style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
  ),
  
  box(width = 4, title = "Download Results", collapsible = TRUE,
      splitLayout(#cellWidths = c("10%", "10%", "25%"),
      radioButtons("wf_include_meta", "Merge results with docvars", choices = list("Yes" = "TRUE", "No" = "FALSE"), inline = TRUE),
      radioButtons("wf_data_sep", "Delimiter for .csv data", choices = list(";" = ";", "," = ","), inline = TRUE)),
      downloadButton("download_wf_data", label = "Download Results (.csv)", width = "100%")
      ),
  
  #### Summary Plot
  
  box(width = 12, title = "Wordfish Plot", collapsible = TRUE,
      column(width = 3,
      radioButtons("wf_plot_type", "Type of result plot", choices = list("Documents" = "documents", "Features" = "features"), inline = TRUE),
      hr(),
      h4("Document Plot Suboptions"),
      textInput("wf_group", "Grouping Variable", placeholder = "e.g., 'party'"),
      textInput("wf_xlab", "X-Axis Label", value = "Position"),
      textInput("wf_ylab", "Y-Axis Label", value = "Document"),
      textInput("wf_title", "Plot Title", placeholder = "e.g., 'Wordfish results'"),
      checkboxInput("wf_show_legend", "Show Legend", value = FALSE),
      conditionalPanel(
        condition = "input.wf_show_legend == true",
        radioButtons("wf_legend_position", "Legend Position", 
                   choices = list("Bottom" = "bottom", 
                                  "Top" = "top",
                                  "Left" = "left",
                                  "Right" = "right"), inline = TRUE),
        textInput("wf_legend_title", "Legend Title", value = "Grouping")
      ),
      radioButtons("wf_position_plot_type", "Type of Document Plot", 
                   choices = list("Point Estimates" = "point", 
                                  "Stacked Density" = "joy", 
                                  "Boxplot" = "boxplot"), 
                   inline = TRUE),
      radioButtons("wf_theme", "Plotting Theme", 
                   choices = list("Default" = "theme_grey", 
                                  "Black & White" = "theme_bw",
                                  "Classic" = "theme_classic",
                                  "Minimal" = "theme_minimal",
                                  "Void" = "theme_void"), inline = TRUE),
      sliderInput("wf_font_size", "Font Size", min = 8, max = 20, step = 1, value = 16),
      sliderInput("wf_transparency", "Transparency", min = 0.05, max = 1, step = 0.05, value = .5),
      textInput("wf_2d", "Plot estimates against varaible", placeholder = "e.g., 'party'")
      ),
      column(width = 9,
      plotOutput("wordfish_plot", height = "800px")),
      column(width = 12,
      hr(),
      h4("Download Plot Options"),
      splitLayout(
      radioButtons("wf_plot_device", "File Format", 
                   choices = list("pdf" = "pdf", 
                                  "png" = "png"),
                                  inline = TRUE),
      numericInput("wf_plot_res", "dpi", min = 72, max = 666, value = 300, width = "75%"),
      numericInput("wf_plot_width", "Width (in)", min = 1, max = 100, value = 7, width = "75%"),
      numericInput("wf_plot_height", "Height (in)", min = 1, max = 100, value = 5, width = "75%"),
      downloadButton("download_wf_plot", label = "Download Plot")
      )
      )
  ),
  
  #### Summary Data
  
  box(width = 12, title = "Wordfish Summary", collapsible = TRUE, collapsed = TRUE,
      dataTableOutput("wordfish_summary")
  )
)