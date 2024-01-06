


# install.packages(c("dplyr", "arrow"))
library(dplyr)
library(arrow)

# List all your .parquet files
parquet_files <- list.files("C:/Users/Administrator/Desktop/hes_apc/", pattern = "\\.parquet$", full.names = TRUE)

# Create an empty data frame to store the combined data
combined_data <- arrow::read_parquet(parquet_files[1])

# Loop through each file and combine the data
for (file_path in parquet_files) {
  # Read the data from the current file
  current_data <- arrow::read_parquet(file_path)  
  
  # Combine the data
  combined_data <- bind_rows(combined_data, current_data)
}

# Now you have a single data frame containing data from all files




## Trial 2 without the for loop: 


library(dplyr)
library(arrow)

# List all your .parquet files
parquet_files <- list.files("C:/Users/Administrator/Desktop/hes_apc/", pattern = "\\.parquet$", full.names = TRUE)

# Combine parquet files into a single data frame with dplyr
combined_data <- bind_rows(lapply(parquet_files, arrow::read_parquet))


# Now you have a single data frame containing data from all files


