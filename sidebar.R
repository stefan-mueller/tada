# Full List of Icons: http://fontawesome.io/icons/ and http://getbootstrap.com/components/#glyphicons.

dashboardSidebar(
  tags$style(".left-side, .main-sidebar {padding-top: 100px}"),
  sidebarMenu(  
    menuItem("Data Upload", tabName = "data_upload", icon = icon("upload")),
    menuItem("Subset and Reshape Corpus", tabName = "subset_reshape_corpus", icon = icon("cut")), #text-height
    menuItem("Keywords in Context", tabName = "kwic", icon = icon("binoculars")), #text-height
    menuItem("Create dfm", tabName = "create_dfm", icon = icon("table")),
    menuItem("Keyness", tabName = "keyness", icon = icon("balance-scale")), #text-height
    menuItem("Text Scaling", icon = icon("arrows"), startExpanded = TRUE,
      menuSubItem("Wordscores", tabName = "wordscores", icon = icon("bar-chart")),
      menuSubItem("Wordfish", tabName = "wordfish", icon = icon("sort-amount-asc")),
      menuSubItem("Correspondence Analysis", tabName = "ca", icon = icon("plus-square-o"))
    ),
    menuItem("Topic Model (LDA)", tabName = "topicmodel", icon = icon("sitemap")),
    menuItem("About", tabName = "about", icon = icon("info-circle")),
    bookmarkButton(label = HTML("&nbsp;&nbsp;Save Progress"), icon = shiny::icon("save"), title = "Save your progress to reload it at a later stage.",
                   style="color: #B5C7CF; background-color: #202D33; border-color: #B5C7CF")
  ),
  width = 250
)