fluidRow(
  
  # Help
  
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_create_dfm.Rmd")
  ),
  
  box(width = 12, title = "dfm Options", collapsible = TRUE,
  
  # Language
  
  column(width = 12,
  h4("Language"),
  #tags$style(HTML(".radio-inline {margin-right: 42px;}")),
  radioButtons("language", "Select language", choices = list("English" = "english",
                                                             "Danish" = "danish",
                                                             "Dutch" = "dutch",
                                                             "Finnish" = "finnish",
                                                             "French" = "french",
                                                             "German" = "german",
                                                             "Hungarian" = "hungarian",
                                                             "Italian" = "italian",
                                                             "Norwegian" = "norwegian",
                                                             "Portuguese" = "portuguese",
                                                             "Spanish" = "spanish",
                                                             "Swedish" = "swedish",
                                                             "Russian" = "russian"
                                                             ), inline = TRUE),
  hr()), 
  
  
  # Text Conversion
  
  column(width = 12,
  h4("Text Conversion"),
  splitLayout(cellWidths = rep("20%", 5),
        radioButtons("lowercase", "Lowercase?", choices = list("Yes" = "yes_lower", "No" = "no_lower"), inline = TRUE),
        radioButtons("stemming", "Stem words?", choices = list("Yes" = "yes_stem", "No" = "no_stem"), selected = "no_stem", inline = TRUE),
        radioButtons("punctuation", "Remove punctuation?", choices = list("Yes" = "yes_punct", "No" = "no_punct"), selected = "no_punct", inline = TRUE),
        radioButtons("symbols", "Remove symbols?", choices = list("Yes" = "yes_symb", "No" = "no_symb"), selected = "no_symb", inline = TRUE),
        radioButtons("numbers", "Remove numbers?", choices = list("Yes" = "yes_numb", "No" = "no_numb"), selected = "no_numb", inline = TRUE)
  ),  
  splitLayout(cellWidths = rep("20%", 4),
        radioButtons("hyphens", "Remove hyphens?", choices = list("Yes" = "yes_hyph", "No" = "no_hyph"), selected = "no_hyph", inline = TRUE),
        radioButtons("url", "Remove URLs?", choices = list("Yes" = "yes_url", "No" = "no_url"), selected = "no_url", inline = TRUE),
        radioButtons("twitter", "Remove Twitter?", choices = list("Yes" = "yes_twitter", "No" = "no_twitter"), selected = "no_twitter", inline = TRUE),
        radioButtons("separators", "Remove separators?", choices = list("Yes" = "yes_sep", "No" = "no_sep"), selected = "yes_sep", inline = TRUE)
  ),
  hr()),
  
  column(width = 12, 
         h4("Remove Terms"),
         splitLayout(
         numericInput("dfm_min_docfreq", HTML("Minimum number of documents <br> a word has to appear in"), value = 1, min = 0, width = "75%"),
         numericInput("dfm_max_docfreq", HTML("Maximum number of documents <br> a word has to appear in"), value = NA, min = 0, width = "75%"),
         numericInput("dfm_min_count", HTML("Minimum <br> word count"), value = 1, min = 0, width = "75%"),
         numericInput("dfm_max_count", HTML("Maximum <br> word count"), value = NA, min = 0, width = "75%"),
         numericInput("dfm_min_nchar", HTML("Minimum word length <br>(characters)"), min = 1, max = 20, value = 1, width = "75%")
         ),
         hr()
  ),

  column(width = 6, 
         h4("Stopwords"), 
         splitLayout(cellWidths = rep("50%", 2),
                     radioButtons("stopwords", "Remove default stopwords list?", choices = list("Yes" = "yes_stopwords", "No" = "no_stopwords"), selected = "no_stopwords", inline = TRUE),
                     fileInput("stopword_csv_file", "Upload custom stopword list", width = "75%")),
         splitLayout(cellWidths = rep("50%", 2),
                     textInput("stopwords_manual", "Additional stopwords (separated by ',')", placeholder = "e.g., 'parliament, party'", width = "75%"),
                     textInput("stopwords_keep", "Words to keep (separated by ',')", placeholder = "e.g., 'the, a, will'", width = "75%"))
         ),
  
  column(width = 6,
         h4("List of Stopwords"),
         verbatimTextOutput("stopwordlist")
         ),

  column(width = 12,
  hr(),
  actionButton("create_dfm", h4(strong("Create dfm")), width = "100%")
  )),
  
  valueBoxOutput("n_docs", width = 4),
  valueBoxOutput("n_terms", width = 4),
  valueBoxOutput("sparse", width = 4),
  
  #### SUMMARY PLOT
  
  box(width = 12, title = "Summary Plot", collapsible = TRUE,
      column(width = 3,
      h4("Plot Options"),
      radioButtons("type_of_dfm_plot", "Type of plot", choices = list("Dotplot" = "dotplot", "Wordcloud" = "wordcloud"), inline = TRUE),
      sliderInput("n_words_freq", "Number of words displayed in summary plot", min = 10, max = 100, step = 1, value = 20),
      sliderInput("min_freq_summary_plot", "Minimum word frequency to be included in plot", min = 5, max = 100, step = 1, value = 50),
      h4(strong("Wordcloud options")),
      sliderInput("perc_rotating", "% of words rotated in wordcloud", min = 0, max = 100, step = 1, value = 25),
      textInput("dfm_group", "Frequencies by Group", placeholder = "e.g., 'party'"),
      radioButtons("dfm_theme", "Plotting Theme", 
                   choices = list("Default" = "theme_grey", 
                                  "Black & White" = "theme_bw",
                                  "Classic" = "theme_classic",
                                  "Minimal" = "theme_minimal",
                                  "Void" = "theme_void"), inline = TRUE),
      sliderInput("dfm_font_size", "Font Size", min = 8, max = 20, step = 1, value = 16)
      
  ),
  
  column(width = 9,
      h4("Plot"),
      plotOutput("dfm_freq_plot", height = "800px", width = "100%")
    ),
  column(width = 12,
         hr(),
         h4("Download Plot Options"),
         splitLayout(
           radioButtons("dfm_plot_device", "File Format", 
                        choices = list("pdf" = "pdf", 
                                       "png" = "png"),
                        inline = TRUE),
           numericInput("dfm_plot_res", "dpi", min = 72, max = 666, value = 300, width = "75%"),
           numericInput("dfm_plot_width", "Width (in)", min = 1, max = 100, value = 7, width = "75%"),
           numericInput("dfm_plot_height", "Height (in)", min = 1, max = 100, value = 5, width = "75%"),
           downloadButton("download_dfm_plot", label = "Download Plot")
         ))
  )
)