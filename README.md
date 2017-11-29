# TADA - The Text as Data App

This repository contains all files of the [**Shiny**](michael.jankowski@uni-oldenburg.de) application **TADA - The Text as Data App**. TADA is work in progress and its functionality will be constantly extended. Currently, the app allows you to upload textual data with document-level variables, get descriptive statistics of your text and to analyze the corpus using various text scaling techniques (Wordscores, Wordfish, Correspondence Analysis) or topic models. All results from this app can be downloaded easily. The app also allows you to visualize most of your models and produces publication ready graphics. Almost all of the text analysis functions avaialble in TADA are based on the [**quanteda**](https://github.com/kbenoit/quanteda) R package. The implementation of LDA is based on the [**topicmodels**](https://cran.r-project.org/web/packages/topicmodels/index.html) package. All plots are based on [**ggplot2**](http://ggplot2.tidyverse.org).


You can access the most recent stable version at: https://tada-gui.shinyapps.io/tada/. 

When you have [R](https://www.r-project.org) installed, you can open the app on your local machine.

```r
# install shiny package if it is not
if (!"shiny" %in% installed.packages()) {
  install.packages("shiny")
}

# load the shiny package
library(shiny)

# easiest way to load TADA is to use runGitHub
runGitHub("tada", "stefan-mueller")
```

How to cite TADA: 

Jankowski, Michael, and Stefan Müller (2017). _TADA: The Text-as-Data-App. Version 0.1._ https://github.com/stefan-mueller/tada.

A BibTeX entry for LaTeX users is:
```
@Manual{,
	author = {Michael Jankowski and Stefan Müller},
	title = {TADA: The Text as Data App},
	note = {Version 0.1}, 
	url = {https://github.com/stefan-mueller/tada},
}
```

Manuals and an extensive documentation are coming soon. If you have recommendations or face problem, please open an issue in this GitHub repository or contact the maintainers: 

- [Michael Jankowski](http://michael-jankowski.de) (University of Oldenburg): michael.jankowski@uni-oldenburg.de

- [Stefan Müller](http://muellerstefan.net), Trinity College Dublin: mullers@tcd.ie
