word <- function() paste(sample(letters[1:5], sample(3:7,1), replace = T), collapse = "")

text <- function() paste(sapply(1:sample(100:1000, 1), function(x) word()), collapse = " ")

cat_var <- paste("Group", sample(1:3, size = 50, replace = TRUE))

score_var <- c(-1,1,rep(NA, 48))

df <- data.frame(text = sapply(1:50, function(x) text()), id = 1:50, cat_var, cont = rnorm(50), docname = sapply(1:50, function(x) word()), score_var, stringsAsFactors = F)

write.table(df, "sample_data/sample_csv.csv", sep = ",", na = "", row.names = F)
haven::write_sav(df, "sample_data/sample_dta.sav")
saveRDS(df, "sample_data/sample_rds.RDS")