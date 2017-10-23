# subset_reshape_corpus

fluidRow(
  
  # Help
  
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_corpus_reshape_subset.Rmd")
  ),
  
  # Subset
  
  box(id = "subset_box", width = 12, title = "Subset Corpus", collapsible = TRUE,
      h4("Subset by Document Level Variables"),
      textInput("subset_condition", "Please enter a condition in the textfield below to subset your corpus", placeholder = "e.g. 'year > 1990 & gender == 1'"),
      h4("Subset by Document Text Length"),
      numericInput("subset_doc_length", "Minimum Number of Words per Document", min = 1, value = 1),
      actionButton("subset_corpus", "Subset Corpus", width = "100%")
      ),
  
  # Data Overview
  
  box(id = "overview_box", width = 12, title = "Data Overview", collapsible = TRUE, collapsed = TRUE,
             h5("The table below displays the first eighth columns of your data (except for the text variable)."),
             dataTableOutput("full_data")
      ),
  
  # Reshape Corpus
  
  box(id = "reshape_box", width = 12, title = "Reshape Corpus", collapsible = TRUE,
      h5("By default, each document in your corpus is the entire text. You can reshape the corpus so that each document in your corpus represents a paragraph or a sentence. Note that this cannot be undone. After reshaping your data to the paragraph or sentences level you have to re-upload your data to get to the document level again. You can also not reshape from paragraph level to the sentences level."),
      radioButtons("reshape_corpus", "Reshape corpus", 
                   choices = list("Paragraphs" = "paragraphs", "Sentences" = "sentences"), 
                   inline = TRUE),
      actionButton("reshape", "Reshape Corpus", width = "20%"),
      h5(strong("Download reshaped data")),
      radioButtons("reshape_data_sep", "Delimiter for .csv data", choices = list(";" = ";", "," = ","), inline = TRUE),
      downloadButton("download_reshape_data", label = "Download Reshaped Data (.csv)", width = "100%")
      ),
  
  # Inspect Corpus
  
  box(id = "inspect_box", width = 12, title = "Inspect Corpus", collapsible = TRUE,
      column(width = 3,
             h4("Summary of Corpus"),
             h5("The table below summarizes the uploaded data."),
             tableOutput("short_summary_table")
      ),
      
      column(width = 9,
             h4("Show Texts"),
             splitLayout(
               textInput("text_selector", "Enter docname or docnumber to display text", placeholder = "e.g., 1 or 'text1'", width = "75%"),
               actionButton("get_display_text", "Show text", width = "75%")),
             textOutput("display_text")
      )
  )
  
)