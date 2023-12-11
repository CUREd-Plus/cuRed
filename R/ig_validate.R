library(knitr)
library(logger)
library(validate)


ig_validate <- function(rules_path, set_name, start_study_day, end_study_day, col_received, col_reference) {

  # Load rules
  rules_path <- normalizePath(rules_path, mustWork = TRUE)
  logger::log_info("Loadeding rules from '{rules_path}'")
  rules <- validate::validator(.file = rules_path)

  out_file_name = paste("out_ig_", set_name, ".txt", sep = "")
  out_file_sum <- file(out_file_name, "a")
  intro = paste("This is an IG validation report for ", set_name, "data set.\n")
  write(intro, out_file_sum)
  line = paste("start_study_day", as.character(start_study_day))
  write(line, out_file_sum)
  line = paste("end_study_day", as.character(end_study_day))
  write(line, out_file_sum)

  # Check date range
  line = paste("received range of dates",
               as.character(sort(unique(
                 data$ARRIVAL_DATE
               ))[2]),
               "to",
               as.character(tail(sort(
                 unique(data$ARRIVAL_DATE)
               ), n = 1)))
  write(line, out_file_sum)

  # Summarise records
  line = paste("Number of records received:", nrow(data))
  write(line, out_file_sum)
  write.table(knitr::kable(validate::summary(validate::confront(
    as.data.frame(data), rules
  ))), file = out_file_sum)
  sentences_comm <- "Elements in common of the two lists"
  write(sentences_comm, out_file_sum)
  comm_list <- intersect(col_received, col_reference)

  write.table(comm_list, file = out_file_sum)

  sentences_diff_wrt_ref <-
    "Elements in reference list that are not in the data received"
  ref_only_list <- setdiff(col_reference, col_received)
  write(sentences_diff_wrt_ref, out_file_sum, append = TRUE)
  write.table(ref_only_list, file = out_file_sum)

  sentences_diff_wrt_datareceived <-
    "Elements received that are not in the reference list"
  data_only_list <- setdiff(col_received, col_reference)
  write(sentences_diff_wrt_datareceived, out_file_sum, append = TRUE)
  write.table(data_only_list, file = out_file_sum)

  write("End of IG validation Report", out_file_sum)

}
