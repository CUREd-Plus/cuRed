

# Load the rmarkdown package
library(rmarkdown)


generate_summary_report <- function(input, output) {
  rmarkdown::render(input, output_format = "html_document", output_file = output)
}


#To run the function, replace location1 with the path to summary.R and 
#replace location 2 with the path of where you want your html file to be saved
#Dont forget in location 2 it should end with filename.html (even if filename.html doesnt exist yet) 
#this will generate the html with the filename of your choice
#generate_summary_report(location1, location2)
#generate_summary_report("C:/Users/Administrator/Documents/cuRed/R/summary.R", "C:/Users/Administrator/Desktop/summary_report_hes_apc_202299.html")

#ran this: generate_summary_report("C:/Users/Administrator/Documents/cuRed/R/summary.R", "C:/Users/Administrator/Desktop/summary_report_hes_apc.html")

