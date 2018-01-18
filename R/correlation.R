## Overwrite function in radiant.basics/correlation.R
## 

summary.correlation_ <- function(object,
                                 cutoff = 0,
                                 covar = FALSE,
                                 dec = 2,
                                 ...) {

	## using correlation_ to avoid print method conflict with nlme
	## calculate the correlation matrix with p.values using the psych package

	cmat <- sshhr( psych::corr.test(object$dat, method = object$method) )

	cr <- apply(cmat$r, 2, formatnr, dec = dec) %>%
		format(justify = "right") %>%
	  set_rownames(rownames(cmat$r))
	cr[is.na(cmat$r)] <- "-"
  cr[abs(cmat$r) < cutoff] <- ""
	ltmat <- lower.tri(cr)
  cr[!ltmat] <- ""

  ## Use format.pval instead if formatnr and get more decimals
	cp <- apply(cmat$p, 2, format.pval, digits = 3,eps=0.001) %>%
		format(justify = "right") %>%
		set_rownames(rownames(cmat$p))
	cp[is.na(cmat$p)] <- "-"
  cp[abs(cmat$r) < cutoff] <- ""
  cp[!ltmat] <- ""

  cat("Correlation\n")
	cat("Data     :", object$dataset, "\n")
	cat("Method   :", object$method, "\n")
	if (cutoff > 0)
	  cat("Cutoff   :", cutoff, "\n")
	if (object$data_filter %>% gsub("\\s","",.) != "")
		cat("Filter   :", gsub("\\n","", object$data_filter), "\n")
	cat("Variables:", paste0(object$vars, collapse = ", "), "\n")
	cat("Null hyp.: variables x and y are not correlated\n")
	cat("Alt. hyp.: variables x and y are correlated\n\n")

	cat("Correlation matrix:\n")
  print(cr[-1,-ncol(cr), drop = FALSE], quote = FALSE)

	cat("\np.values:\n")
  print(cp[-1,-ncol(cp), drop = FALSE], quote = FALSE)

	if (covar) {
	  cvmat <- sshhr( cov(object$dat, method = object$method) )
		cvr <- apply(cvmat, 2, formatnr, dec = dec) %>%
			format(justify = "right") %>%
			set_rownames(rownames(cvmat))
	  cvr[abs(cmat$r) < cutoff] <- ""
		ltmat <- lower.tri(cvr)
	  cvr[!ltmat] <- ""

	  cat("\nCovariance matrix:\n")
	  print(cvr[-1,-ncol(cvr), drop = FALSE], quote = FALSE)
	}

  rm(object)
}
