# Explore Corpus

fluidRow(
  
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_kwic.Rmd")
  ),
  
  # KWIC
  
    box(width = 12, title = "Keywords in Context (KWIC)", collapsible = TRUE,
        #h4("KWIC Options"),
        splitLayout(cellWidths = rep("20%", 5),
        textInput("kwic_word", "Enter keyword", placeholder = "e.g., 'budget'", width = "75%"),
        radioButtons("kwic_ignore_case", "Case insensitive?", choices = list("Yes" = TRUE, "No" = FALSE), inline = TRUE),
        sliderInput("kwic_window", "Window around the keyword", min = 1, max = 10, step = 1, value = 3, width = "75%"),
        #h5(strong("Download KWIC Results")),
        downloadButton("download_kwic_data", label = "Download KWIC Data (.csv)", width = "100%"),
        radioButtons("kwic_data_sep", "Delimiter for .csv data", choices = list(";" = ";", "," = ","), inline = TRUE)
        ),
        actionButton("get_kwic", "Start KWIC Analysis", width = "100%",
                     style="color: #fff; background-color: #2A3135; border-color: #B9C6CE"),
        h4("KWIC Results"),
        dataTableOutput("kwic_table")
    )
)  


