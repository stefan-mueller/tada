# Topic Model

fluidRow(
  
  # Help
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_topicmodel.Rmd")
  ),
  
  box(width = 12, title = "LDA Options", collapsible = TRUE,
      splitLayout(cellWidths = c("25%"),
                  numericInput("lda_topics", "Number of topics", min = 2, value = 2, width = "75%"),
                  textInput("lda_seed", "Seed", value = "123", width = "75%"),
                  numericInput("lda_burnin", "Number of burnin iterations", min = 1, value = 100, width = "75%"),
                  numericInput("lda_iter", "Number of iterations", min = 1, value = 100, width = "75%")
      ),
      actionButton("estimate_lda", h4(strong("Estimate LDA")), width = "100%",
                   style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
  ),
  
  #### SUMMARY
  
  box(width = 12, title = "LDA Summary", collapsible = TRUE, collapsed = FALSE,
      sliderInput("lda_nlabel", "Number of words displayed for each topic", min = 1, max = 15, value = 10),
      dataTableOutput("lda_topics")
  )
)