fluidRow(

# Welcome
  
box(width = 12, title = "Welcome to TADA - The Text As Data App", collapsible = TRUE,
    includeMarkdown("documentation/welcome_tada.Rmd")
    ),

# Help

box(width = 12, title = "Help (press '+' to expand)", collapsible = TRUE, collapsed = TRUE,
    includeMarkdown("documentation/help_upload.Rmd")
),

# Upload

box(width = 12, title = "Select Data", collapsible = TRUE,
    column(width = 8,
    h4("Upload Data"),
    h6(em("Accepted formats are: .csv / .xlsx / .sav (SPSS) / .dta (Stata) / .rds (R). Max. 3 GB!")),
    splitLayout(cellWidths = c("50%","25%", "25%"),
    fileInput("uploaded_file", "Select File", width = "80%"),
    radioButtons("csv_delim", label = HTML("CSV Option:<br>Type of Delimiter"),
                  choices = list("auto" = "auto", ";" = ";", "," = ",", "tab" = "\t"),
                  inline = TRUE),
    checkboxInput("use_default", HTML("Use sample corpus"), value = FALSE)
    ),
    actionButton("upload_file", h4(strong("Upload Data!")), width = "100%",
                 style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
    ), # end box

    column(width = 4,
    h4("Set Text and Document Variables"),
    textInput("text_var", label = "Name of Text Variable", placeholder = "e.g. 'text'"),
    textInput("doc_var", label = "Name of Document ID Variable", placeholder = "e.g. 'document'"),
    actionButton("set_vars", "Set Text and Doc Variables!", width = "100%",
                 style="color: #fff; background-color: #2A3135; border-color: #B9C6CE")
)),

uiOutput("warning_upload"),

infoBoxOutput(width = 12, "info_text"),

box(id = "upload_data_info", width = 12, title = "Variable Overview", collapsible = TRUE,
    h5("In the table below all variable names and types of your data are displayed."),
    dataTableOutput("report_coltypes"))
)