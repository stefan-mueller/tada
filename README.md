# TADA - The Text as Data App

This repository contains all files of the Shiny Application. TADA is work in progress and its functionality will be constantly extended. Currently, the app allows you to upload your textual data with document-level variables, get descriptive statistics of your text and to analyze the corpus using various text scaling techniques or topic models. All results from this app can be downloaded and stored on your computer. The app also allows you to visualize most of your models and produces publication ready graphics.

You can access the most recent stable version at: https://tada-gui.shinyapps.io/tada/. 

When you have [R](https://www.r-project.org) installed, you can open the app on your local machine.

```r
# If shiny package is not installed
if (!require("shiny")) {
    install.packages("shiny")
}

library(shiny)

# Easiest way is to use runGitHub
runGitHub("tada", "stefan-mueller")
```


How to cite TADA: 

Jankowski Michael, and Stefan Müller (2017). _TADA: The Text-as-Data-App. Version 0.1._ http://tada-gui.com.

A BibTeX entry for LaTeX users is:
```
@Manual{,
	author = {Michael Jankowski and Stefan Müller},
	title = {TADA: The Text as Data App},
	note = {Version XXXX}, 
	url = {http://tada-gui.com},
}
```

Manuals and an extensive documentation are coming soon. If you have recommendations or face problem, please open an Issue in this GitHub repository.
