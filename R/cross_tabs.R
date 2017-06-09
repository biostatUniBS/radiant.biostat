## Overwrite cross_tabs in radiant_basics/cross_tabs.R
## - use Yates correction

cross_tabs <- function(dataset, var1, var2,
                       data_filter = "") {

	dat <- getdata(dataset, c(var1, var2), filt = data_filter)
  if (!is_string(dataset)) dataset <- "-----"

  ## Use simulated p-values when
  # http://stats.stackexchange.com/questions/100976/n-1-pearsons-chi-square-in-r
  # http://stats.stackexchange.com/questions/14226/given-the-power-of-computers-these-days-is-there-ever-a-reason-to-do-a-chi-squa/14230#14230
  # http://stats.stackexchange.com/questions/62445/rules-to-apply-monte-carlo-simulation-of-p-values-for-chi-squared-test

  ## creating and cleaning up the table
	tab <- table(dat[[var1]], dat[[var2]])
	tab[is.na(tab)] <- 0
	tab <- tab[ ,colSums(tab) > 0] %>% {.[rowSums(.) > 0, ]} %>% as.table

	cst <- sshhr( chisq.test(tab, correct = TRUE) )

	## adding the % deviation table
	# cst$deviation <- with(cst, (observed-expected) / expected)
	cst$chi_sq	<- with(cst, (observed - expected)^2 / expected)

	## dat not needed in summary or plot
	rm(dat)

  as.list(environment()) %>% add_class("cross_tabs")
}
