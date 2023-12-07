

# Load the rmarkdown package
library(rmarkdown)


generate_summary_report <- function(input, output) {
  rmarkdown::render(input, output_format = "html_document", output_file = output)
}


#to run the command enter the path to summary.R instead of path1 and the output path (where you want your html file to be saved) instead of path2
generate_summary_report(path1, path2)


