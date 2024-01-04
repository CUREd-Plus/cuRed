
# Read the CSV data into a data frame
df <- read.csv("C:/Users/Administrator/Desktop/UOS CUREd+ Data Dictionaries v1 IN PROGRESS - APC.csv")

# Extract column names where the value in column H is equal to "link"
link_columns  <- df[df[, 8] == "link", 2] 

# Define the output file path
output_file_path <- 'C:/Users/Administrator/Desktop/output_for_coded_columns.txt'

# Export the column names to a text file
write.table(link_columns, file = output_file_path, row.names = FALSE, col.names = FALSE)

#Notes: Make sure you have the correct path for the sheet, when you are downloading it, you can choose to download a sheet or all sheets, Ive downloaded only one sheet (APC) 


#After you get the txt file output_for_coded_columns, you can now copy the list of columns and put them in coded_columns.txt
