## Overwrite cross_tabs in radiant_basics/cross_tabs.R
## - use Yates correction

cross_tabs <- function(dataset, var1, var2, tab = NULL, data_filter = "") {
  
  if (is.table(tab)) {
    df_name <- deparse(substitute(tab))
    
    if (missing(var1) || missing(var2)) {
      nm <- names(dimnames(tab))
      var1 <- nm[1]
      var2 <- nm[2]
    }
    
    if (is_empty(var1) || is_empty(var2)) {
      return("The provided table does not have dimension names. See ?cross_tabs for an example" %>%
               add_class("cross_tabs"))
    }
  } else {
    df_name <- if (!is_string(dataset)) deparse(substitute(dataset)) else dataset
    dataset <- get_data(dataset, c(var1, var2), filt = data_filter)
    
    ## Use simulated p-values when
    # http://stats.stackexchange.com/questions/100976/n-1-pearsons-chi-square-in-r
    # http://stats.stackexchange.com/questions/14226/given-the-power-of-computers-these-days-is-there-ever-a-reason-to-do-a-chi-squa/14230#14230
    # http://stats.stackexchange.com/questions/62445/rules-to-apply-monte-carlo-simulation-of-p-values-for-chi-squared-test
    
    if (any(summarise_all(dataset, funs(does_vary)) == FALSE)) {
      return("One or more selected variables show no variation. Please select other variables." %>%
               add_class("cross_tabs"))
    }
    
    tab <- table(dataset[[var1]], dataset[[var2]])
    tab[is.na(tab)] <- 0
    tab <- tab[, colSums(tab) > 0] %>%
    {.[rowSums(.) > 0, ]} %>%
      as.table()
    ## dataset not needed in summary or plot
    rm(dataset)
  }
  
  cst <- sshhr(chisq.test(tab, correct = TRUE))
  
  ## adding the % deviation table
  cst$chi_sq <- with(cst, (observed - expected) ^ 2 / expected)
  
  res <- tidy(cst) %>%
    mutate(parameter = as.integer(parameter))
  elow <- sum(cst$expected < 5)
  
  if (elow > 0) {
    res$p.value <- chisq.test(cst$observed, simulate.p.value = TRUE, B = 2000) %>% tidy() %>% .$p.value
    res$parameter <- paste0("*", res$parameter, "*")
  }
  
  as.list(environment()) %>% add_class("cross_tabs")
}
