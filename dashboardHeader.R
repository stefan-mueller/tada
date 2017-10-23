dashboardHeader(
  
  tags$li(class = "dropdown",
          tags$style(".main-header {max-height: 75px}"),
          tags$style(".main-header .logo {height: 75px;}"),
          tags$style(".sidebar-toggle {height: 75px; padding-top: 1px !important;}"),
          tags$style(".navbar {min-height:75px !important}")
  ),
  
  #title = tags$a(href='http://quanteda.io', tags$img(src = 'quanteda_logo.svg')), 
  #title = "TADA - The Text as Data App", 
  title = span(img(src = "tada_logo.png", width = 200, height = 75)),
  
  titleWidth = 250
)

