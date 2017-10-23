########### Plot Function for Worscores and Wordfish

#ie2010dfm <- dfm(data_corpus_irishbudget2010, verbose = FALSE)
#model <- textmodel_wordfish(ie2010dfm, dir = c(6,5))
#corp <- data_corpus_irishbudget2010
#by_var <- docvars(corp)$party
#by_var = "party"
#model <- textmodel_wordscores(data_dfm_lbgexample, c(seq(-1.5, 1.5, .75), NA))
#ws_pred <- predict(model, rescaling = "mv")

#df <- data.table::fread("sample_data/sample_csv.csv", data.table = F, stringsAsFactors = F)
#corp = corpus(df, text_field = "text")
#dfm <- dfm(corp)
#by_var = "cat_var"
#model <- textmodel_wordscores(dfm, docvars(corp, "score_var"))
#ws_pred <- predict(model, rescaling = "mv")

plot_scaling_model <- function(model, corp, ci, by_var = NULL, ws_pred = NULL){
  
  # If Model == Wordfish
  
  if(grepl("wordfish", class(model)[1])){
  
  wf_show_legend = input$wf_show_legend
    
  # Estimate qnorm value for ci
    
  ci = input$wf_ci/100
  q_val <- ci + (1-ci)/2  
    
  # Choose theme
    
  selected_theme <- eval(parse(text = paste0("ggplot2::",input$wf_theme,"(", base_size = input$wf_font_size,")")))
    
  position_df <- data.frame(theta = model@theta, 
                            llci = (model@theta - qnorm(q_val)*model@se.theta),
                            ulci = (model@theta + qnorm(q_val)*model@se.theta),
                            docs = model@docs, stringsAsFactors = F)
  
  full_data <- merge(position_df, docvars(corp), by.x = "docs", by.y = "row.names", all.x = TRUE)
  
  full_data$order_var <- stats::reorder(full_data$docs, full_data$theta)

  if(input$wf_2d != ""){
    
    x_lab <- input$wf_xlab
    y_lab <- input$wf_ylab
    
    if(!is.numeric(full_data[,input$wf_2d])){
    
      x_lab <- input$wf_ylab
      y_lab <- input$wf_xlab
      
      plot <- ggplot2::ggplot(full_data, aes_string(y = "theta", x = input$wf_2d)) +
      ggplot2::geom_boxplot() +
      selected_theme +
      ggplot2::xlab(x_lab) +
      ggplot2::ylab(y_lab) +
      ggplot2::ggtitle(input$wf_title)

    } else{
      
      x_lab <- input$wf_xlab
      y_lab <- input$wf_ylab
      
      plot <- ggplot2::ggplot(full_data, aes_string(y = "theta", x = input$wf_2d)) +
        ggplot2::geom_point() +
        selected_theme +
        ggplot2::xlab(x_lab) +
        ggplot2::ylab(y_lab) +
        ggplot2::ggtitle(input$wf_title)
    }
    
  } else{
  
  if(input$wf_position_plot_type == "point"){
    
    x_lab <- input$wf_ylab
    y_lab <- input$wf_xlab
    
    plot <- ggplot2::ggplot(full_data, aes_string(y = "theta", x = "order_var", ymin = "llci", ymax = "ulci", color = by_var)) +
      ggplot2::geom_pointrange(show.legend = wf_show_legend) +
      selected_theme +
      ggplot2::coord_flip() +
      ggplot2::xlab(x_lab) +
      ggplot2::ylab(y_lab) +
      ggplot2::labs(color = input$wf_legend_title) +
      ggplot2::ggtitle(input$wf_title) +
      ggplot2::theme(legend.position = input$wf_legend_position)
  }
  
  if(input$wf_position_plot_type == "joy"){
    
    shiny::validate(need(!is.null(by_var), label = "Please specify a grouping variable."))

    group_mean <- tapply(full_data$theta, full_data[by_var], function(x) mean(x, na.rm = T))

    full_data$order_var <- factor(full_data[,by_var], levels = names(group_mean)[order(group_mean)])
    
    plot <- ggplot2::ggplot(full_data, aes_string(x = "theta", y = "order_var", fill = "order_var")) +
      ggridges::geom_density_ridges(scale = 0.95, color = 0, alpha = input$wf_transparency, show.legend = wf_show_legend) +
      selected_theme +
      ggplot2::xlab(input$wf_xlab) +
      ggplot2::ylab(input$wf_ylab) +
      ggplot2::labs(color = input$wf_legend_title, fill = input$wf_legend_title) +
      ggplot2::ggtitle(input$wf_title) +
      ggplot2::theme(legend.position = input$wf_legend_position)
  }
  
  if(input$wf_position_plot_type == "boxplot"){
    
    validate(need(!is.null(by_var), label = "Please specify a grouping variable."))
    
    x_lab <- input$wf_ylab
    y_lab <- input$wf_xlab
    
    group_mean <- tapply(full_data$theta, full_data[by_var], function(x) mean(x, na.rm = T))
    
    full_data$order_var <- factor(full_data[,by_var], levels = names(group_mean)[order(group_mean)])
    
    plot <- ggplot2::ggplot(full_data, aes_string(y = "theta", x = "order_var", color = "order_var", fill = "order_var")) +
      ggplot2::geom_boxplot(alpha = input$wf_transparency, show.legend = wf_show_legend) +
      ggplot2::coord_flip() +
      selected_theme +
      ggplot2::xlab(x_lab) +
      ggplot2::ylab(y_lab) +
      ggplot2::labs(color = input$wf_legend_title, fill = input$wf_legend_title) +
      ggplot2::ggtitle(input$wf_title) +
      ggplot2::theme(legend.position = input$wf_legend_position)
  }
  
  } # end else 2D
  
  } # end wordfish
  
  
  # if model == Wordscores
  
  if(grepl("wordscores", class(model)[1])){
    
    ws_show_legend = input$ws_show_legend
    
    # Choose theme
    
    selected_theme <- eval(parse(text = paste0("ggplot2::",input$ws_theme,"(", base_size = input$ws_font_size,")")))
    
    rescale <- ifelse(input$ws_rescale == "none", "raw", input$ws_rescale)

    position_df <- data.frame(theta = ws_pred@textscores[,paste0("textscore_",rescale)], 
                              llci = ws_pred@textscores[,paste0("textscore_",rescale,"_lo")],
                              ulci = ws_pred@textscores[,paste0("textscore_",rescale,"_hi")],
                              docs = rownames(ws_pred@textscores), stringsAsFactors = F)
    
    full_data <- merge(position_df, docvars(corp), by.x = "docs", by.y = "row.names", all.x = TRUE)
    
    full_data$order_var <- stats::reorder(full_data$docs, full_data$theta)
    
    if(input$ws_exclude_ref == "TRUE") full_data <- full_data[is.na(full_data[,input$ws_scores]),]
    
    if(input$ws_position_plot_type == "point"){
      
      x_lab <- input$ws_ylab
      y_lab <- input$ws_xlab
      
      plot <- ggplot2::ggplot(full_data, aes_string(y = "theta", x = "order_var", ymin = "llci", ymax = "ulci", color = by_var)) +
        ggplot2::geom_pointrange(show.legend = ws_show_legend) +
        selected_theme +
        ggplot2::coord_flip() +
        ggplot2::xlab(x_lab) +
        ggplot2::ylab(y_lab) +
        ggplot2::labs(color = input$ws_legend_title) +
        ggplot2::ggtitle(input$ws_title) +
        ggplot2::theme(legend.position = input$ws_legend_position)
    }
    
    if(input$ws_position_plot_type == "joy"){
      
      shiny::validate(need(!is.null(by_var), label = "Please specify a grouping variable."))
      
      group_mean <- tapply(full_data$theta, full_data[by_var], function(x) mean(x, na.rm = T))
      
      full_data$order_var <- factor(full_data[,by_var], levels = names(group_mean)[order(group_mean)])
      
      plot <- ggplot2::ggplot(full_data, aes_string(x = "theta", y = "order_var", fill = "order_var")) +
        ggridges::geom_density_ridges(scale = 0.95, color = 0, alpha = input$ws_transparency, show.legend = ws_show_legend) +
        selected_theme +
        ggplot2::xlab(input$ws_xlab) +
        ggplot2::ylab(input$ws_ylab) +
        ggplot2::labs(color = input$ws_legend_title, fill = input$ws_legend_title) +
        ggplot2::ggtitle(input$ws_title) +
        ggplot2::theme(legend.position = input$ws_legend_position)
    }
    
    if(input$ws_position_plot_type == "boxplot"){
      
      validate(need(!is.null(by_var), label = "Please specify a grouping variable."))
      
      x_lab <- input$ws_ylab
      y_lab <- input$ws_xlab
      
      group_mean <- tapply(full_data$theta, full_data[by_var], function(x) mean(x, na.rm = T))
      
      full_data$order_var <- factor(full_data[,by_var], levels = names(group_mean)[order(group_mean)])
      
      plot <- ggplot2::ggplot(full_data, aes_string(y = "theta", x = "order_var", color = "order_var", fill = "order_var")) +
        ggplot2::geom_boxplot(alpha = input$ws_transparency, show.legend = ws_show_legend) +
        ggplot2::coord_flip() +
        selected_theme +
        ggplot2::xlab(x_lab) +
        ggplot2::ylab(y_lab) +
        ggplot2::labs(color = input$ws_legend_title, fill = input$ws_legend_title) +
        ggplot2::ggtitle(input$ws_title) +
        ggplot2::theme(legend.position = input$ws_legend_position)
    }
    
  } # end Wordscores
  
  # If Model == CA
  
  if(grepl("textmodel_ca", class(model)[1])){
    
    ca_show_legend = input$ca_show_legend
    
    # Axis Labels
    
    if(input$ca_xlab == "") x_lab <- paste0("Dimension ", input$ca_dim_1) else x_lab <- input$ca_xlab
    if(input$ca_ylab == "") y_lab <- paste0("Dimension ", input$ca_dim_2) else y_lab <- input$ca_ylab
    
    # Choose theme
    
    selected_theme <- eval(parse(text = paste0("ggplot2::",input$ca_theme,"(", base_size = input$ca_font_size,")")))
    
    position_df <- data.frame(model$rowcoord, 
                              docs = rownames(model$rowcoord),
                              stringsAsFactors = F)
    
    full_data <- merge(position_df, docvars(corp), by.x = "docs", by.y = "row.names", all.x = TRUE)
    
    #full_data$order_var <- stats::reorder(full_data$docs, full_data$theta)
    
    x_ax <- paste0("Dim",input$ca_dim_1)
    y_ax <- paste0("Dim",input$ca_dim_2)
    
    if(input$ca_position_plot_type == "point"){
      
      #y_lab <- x_lab
      #x_lab <- y_lab
      
      plot <- ggplot2::ggplot(full_data, aes_string(y = x_ax, x = y_ax, color = by_var)) +
        ggplot2::geom_point(show.legend = ca_show_legend) +
        selected_theme +
        ggplot2::coord_flip() +
        ggplot2::xlab(y_lab) +
        ggplot2::ylab(x_lab) +
        ggplot2::labs(color = input$ca_legend_title) +
        ggplot2::ggtitle(input$ca_title) +
        ggplot2::theme(legend.position = input$ca_legend_position)
    }
    
    if(input$ca_position_plot_type == "joy"){
      
      shiny::validate(need(!is.null(by_var), label = "Please specify a grouping variable."))
      
      group_mean <- tapply(full_data[,x_ax], full_data[by_var], function(x) mean(x, na.rm = T))
      
      full_data$order_var <- factor(full_data[,by_var], levels = names(group_mean)[order(group_mean)])
      
      plot <- ggplot2::ggplot(full_data, aes_string(x = x_ax, y = "order_var", fill = "order_var")) +
        ggridges::geom_density_ridges(scale = 0.95, color = 0, alpha = input$ca_transparency, show.legend = ca_show_legend) +
        selected_theme +
        ggplot2::xlab(x_lab) +
        ggplot2::ylab(y_lab) +
        ggplot2::ggtitle(input$ca_title) +
        ggplot2::labs(color = input$ca_legend_title, fill = input$ca_legend_title) +
        ggplot2::theme(legend.position = input$ca_legend_position)
    }
    
    if(input$ca_position_plot_type == "boxplot"){
      
      validate(need(!is.null(by_var), label = "Please specify a grouping variable."))
      
      group_mean <- tapply(full_data[,x_ax], full_data[by_var], function(x) mean(x, na.rm = T))
      
      full_data$order_var <- factor(full_data[,by_var], levels = names(group_mean)[order(group_mean)])
      
      plot <- ggplot2::ggplot(full_data, aes_string(y = x_ax, x = "order_var", color = "order_var", fill = "order_var")) +
        ggplot2::geom_boxplot(alpha = input$ca_transparency, show.legend = ca_show_legend) +
        ggplot2::coord_flip() +
        selected_theme +
        ggplot2::xlab(x_lab) +
        ggplot2::ylab(y_lab) +
        ggplot2::ggtitle(input$ca_title) +
        ggplot2::labs(color = input$ca_legend_title, fill = input$ca_legend_title) +
        ggplot2::theme(legend.position = input$ca_legend_position)
    }
    
  } # end CA
  
  plot
}