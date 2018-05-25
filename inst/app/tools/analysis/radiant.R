#' Launch Radiant in the default browser
#'
#' @details See \url{http://vnijs.github.io/radiant} for documentation and tutorials
#'
#' @export
radiant.biostat <- function() {
  if (!"package:radiant.biostat" %in% search())
    if (!require(radiant.biostat)) stop("Calling radiant.biostat start function but radiant.design is not installed.")
  runApp(system.file("app", package = "radiant.biostat"), launch.browser = TRUE)
}
