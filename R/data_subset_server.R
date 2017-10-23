#####################################################
#################### Subset Data  ###################
#####################################################

## Note: This file subsets the dataframe (not the corpus object)

observeEvent(input$subset_corpus, {
  
  corp <- corpus_container$corp
  
  if(input$subset_condition != ""){
    corp <- try(corpus_subset(corp, eval(parse(text = input$subset_condition))))
    if(class(corp)[1] == "try-error"){
      shinyjs::alert("Subset condition is not valid! Corpus has not been subsetted.")
      corp <- corpus_container$corp
    }
  }
  
  min_length <- input$subset_doc_length
  
  if(is.na(input$subset_doc_length)) min_length <- 1
  
  if(min_length > 1){
  docvars(corp, "length_condition") <- stringi::stri_count(texts(corp), regex = "\\S+") >= min_length  
  corp <- corpus_subset(corp, length_condition)
  }
  
  n_docs <- ndoc(corp)
  
  if(n_docs == 0){
    shinyjs::alert("Corpus does not contain any documents due to subsetting! Ignoring subsetting and returning original corpus.")
    corp <- corpus_container$corp
  }
  
  corpus_container$corp <- corp
  
})