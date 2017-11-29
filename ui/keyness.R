# Explore Corpus

fluidRow(
  
  box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
      includeMarkdown("documentation/help_kwic.Rmd")
  ),
  
  # KWIC
  
    box(width = 12, title = "Keyness Analysis", collapsible = TRUE,
        #h4("KWIC Options"),
        splitLayout(cellWidths = c("25%", "25%", "25%", "25%"),
        textInput("keyness_variable", "Enter Variable to Estimate Keyness", width = "75%"),
        textInput("keyness_target", "Keyness Target (Level of Keyness Variable)", width = "75%"),
        radioButtons("keyness_measure", "Keyness Measure", choices = list("Chi2" = "chi2", "Likelihood Ratio" = "lr"), inline = TRUE, width = "75%"),
        radioButtons("keyness_ref", "Show reference in plot", choices = list("Show reference" = "show", "Hide reference" = "hide"), inline = TRUE, width = "75%")
        #h5(strong("Download KWIC Results")),
        ),
        actionButton("get_keyness", h4(strong("Start Keyness Analysis")), width = "100%",
                     style="color: #fff; background-color: #2A3135; border-color: #B9C6CE"),
        h4("Keyness Result"),
        plotOutput("keyness_plot", height = "800px", width = "100%")
    )
)  


