## ui for biostat menu in radiant
do.call(navbarPage,
  c("Radiant", getOption("radiant.nav_ui"), getOption("radiant.biostat_ui"),
    getOption("radiant.shared_ui"), help_menu("help_biostat_ui"))
)
