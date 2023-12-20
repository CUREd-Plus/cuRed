library(stringr)


#' Load configuration options
#' @param active_config The specific [configuration](https://rstudio.github.io/config/articles/config.html) to use. Default: "default"
#' @param config_path Path of the global configuration file. Default: "extdata/config/config.yaml".
#' @param data_set_config_path Path of the data set configuration file. Default: "extdata/config/{data_set_id}.yaml".
load_config <- function(data_set_id = NA, active_config = NA, config_path= NA, data_set_config_path = NA) {

  # Specify which configuration namespace to use
  if (is.na(active_config)) { active_config = Sys.getenv("R_active_config", "default") }

  # Load global options
  # https://rstudio.github.io/config/reference/
  if (is.na(config_path)) { config_path = extdata_path("config/config.yaml") }
  logger::log_info("Loading '{config_path}' ('{active_config}' options)")
  config <- config::get(file = config_path, config = active_config)


  # Load data set options
  if (is.na(data_set_config_path)) {
    data_set_config_path <- extdata_path(stringr::str_glue("config/{data_set_id}.yaml"))
  }
  logger::log_info("Loading '{data_set_config_path}'")
  config = config::merge(config, config::get(file = data_set_config_path, config = active_config))

  return(config)
}
