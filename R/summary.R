#' ---
#' title: "Summary Report"
#' author: "cured"
#' date: "`r Sys.Date()`"
#' output:
#'  html_document:
#'    theme: cosmo
#'    toc: true
#'editor_options:
#'  chunk_output_type: console
#' ---


#+ load data, echo=FALSE,message=FALSE, warning=FALSE
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(arrow)
library(ggplot2)
library(lubridate)


start_time <- Sys.time()
print(paste("Start time:", start_time))

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

data <- combined_data




#For Investigation or Treatment Code
# Read the list of column names from the text file
coded_columns <-
  readLines("C:/Users/Administrator/Documents/cuRed/inst/extdata/codes/coded_columns.txt")
# Convert the list to a character vector
coded_columns <-  trimws(coded_columns)  # Trim leading/trailing whitespaces
coded_columns <-  unique(coded_columns)  # Remove duplicates

#For LSOA
# Read the list of column names from the text file
lsoa <-  readLines("C:/Users/Administrator/Documents/cuRed/inst/extdata/codes/lsoa.txt")
# Convert the list to a character vector
lsoa <-  trimws(lsoa)  # Trim leading/trailing whitespaces
lsoa <-  unique(lsoa)  # Remove duplicates

#Import map data
map_data <-  read.csv("C:/Users/Administrator/Documents/cuRed/inst/extdata/lsoadata/lsoa_latlong.csv")

#Replace 999 with Na in Age columns
data <- data %>%
  mutate_at(vars(ACTIVAGE, ADMIAGE), ~ ifelse(. == 999, NA, .))

# column types count
column_counts <- table(sapply(data, class))
cat("Total number of columns:", length(data),"\n")
cat("Total number of rows:", nrow(data), "\n")
cat("Column type counts:")
for (col_type in names(column_counts)) {
  cat(paste(col_type, ":", column_counts[col_type], "columns\n"))
}


#+ loop through the columns, echo =FALSE

for (col_name in names(data)) {
  # Get the column type
  col_type <- class(data[[col_name]])
  num_nas <- sum(is.na(data[[col_name]]))
  
  # Print the column number, name, and type
  cat("Column Number: ", which(names(data) == col_name), "\n")
  cat("Column Name: ", col_name, "\n")
  cat("Column Type: ", col_type, "\n")
  cat("Number of NAs: ", num_nas, "\n")
  if (col_name %in% coded_columns) {
    p <- ggplot() +
      theme_void() +  # A theme without any axes or grid
      geom_rect(aes(
        xmin = 2,
        xmax = 8,
        ymin = 5,
        ymax = 8
      ), fill = "white") +
      geom_text(
        aes(x = 5, y = 6.5, label = "This column is coded by a list according to the Data Dictionary"),
        col = "red" ,
        size = 5,
        fontface = "bold"
      )
    print(p)
  }
  
  # Check if the column is of unrecognized date format and convert it
  # data[[col_name]] <- convertToDate(data[[col_name]]) wont be needing it anymore bcz the file is coming from Joe's csv_binary so dataypes are all correct
  
  # Perform actions based on the column type
  if (col_type == "numeric" || col_type == "integer") {
    # Summary for numeric columns
    cat("Summary:\n")
    print(summary(data[[col_name]]))
    
    # Check if all values in the column are NAs
    if (all(is.na(data[[col_name]]))) {
      cat("All values in the column are NAs; skipping Histogram and Boxplot\n")
    } else {
      # Check if min equals max (and there are no missing values)
      if (!anyNA(data[[col_name]]) &&
          min(data[[col_name]]) == max(data[[col_name]])) {
        cat("Min equals Max: skipping Histogram and Boxplot\n")
      } else {
        # Create a histogram with a specified number of breaks (e.g., 30)
        #cat("Histogram:\n")
        hist(
          data[[col_name]],
          main = col_name,
          xlab = col_name,
          breaks = 30,
          col = "lightblue"
        )
        
        # Create a boxplot with outliers and whiskers
        #cat("Boxplot:\n")
        boxplot(
          data[[col_name]],
          main = col_name,
          xlab = col_name,
          outline = TRUE,
          col = "#D8BFD8"
        ) # Pastel Purple
      }
    }
  }
  
  else if (col_type == "character") {
    # Number of unique values for character columns
    unique_values <- unique(data[[col_name]])
    num_unique_values <- length(unique_values)
    cat("Number of Unique Values: ", num_unique_values, "\n")
    
    # Check if there are non-missing values in the column
    if (any(!is.na(data[[col_name]]))) {
      # Check if the column is not entirely unique
      if (num_unique_values != nrow(data)) {
        # Find the top three most recurring values and their counts
        value_counts <- table(data[[col_name]], useNA = "always")
        value_counts_non_na <-
          value_counts[!is.na(names(value_counts))]
        sorted_values <-
          sort(value_counts_non_na, decreasing = TRUE)
        top_values <-
          names(sorted_values)[1:min(3, length(sorted_values))]
        top_counts <-
          as.vector(sorted_values[1:min(3, length(sorted_values))])
        
        cat("Top Three Most Recurring Values and Counts:\n")
        for (i in seq_along(top_values)) {
          cat(top_values[i], ": ", top_counts[i], "\n")
        }
      } else {
        cat("Column has all unique values.\n")
      }
    } else {
      cat("Column has all NAs.\n")
    }
    
    if (col_name %in% lsoa) {
      cat("This column has LSOA data\n")
      cat("Performing LSOA map at the bottom of the report\n")
      # Merge the datasets based on the common column
      merged_data <-
        merge(data, map_data, by.x = "LSOA01", by.y = "lsoa11cd")
      
      # Create a Leaflet map
      my_map <- leaflet(merged_data) %>%
        addTiles() %>%
        
        # Add marker clusters with count labels
        addAwesomeMarkers(
          lng = ~ longitude,
          lat = ~ latitude,
          label = ~ LSOA01,
          clusterOptions = markerClusterOptions(
            showCoverageOnHover = FALSE,
            # Disable coverage display on hover
            spiderfyOnMaxZoom = FALSE     # Disable spiderfy on max zoom
          )
        ) %>%
        
        # Customize marker cluster appearance
        addLegend(
          "bottomright",
          title = "Cluster Count",
          colors = c("lightgreen", "#FFFF99", "#FFC266"),
          labels = c("1-10", "11-100", ">100"),
          opacity = 1
        )
      
      
    }
  }
  
  else if (col_type == "factor") {
    # Summary for factor columns
    cat("Summary:\n")
    print(summary(data[[col_name]]))
  } else if (col_type == "logical") {
    # Sum for logical columns
    cat("Sum:\n")
    print(sum(data[[col_name]]))
    
    
  }
  else if (col_type == "Date") {
    
    # Replace dates with year 1800 or 1801 with NA
    data[[col_name]][year(data[[col_name]]) %in% c(1800, 1801,1900,1901)] <- NA
    
    
    # Calculate and Print Date Range
    date_range <- range(data[[col_name]], na.rm = TRUE)
    sorted_dates <- sort(unique(data[[col_name]]))
    
    cat("Min: ", format(sorted_dates[1], "%Y-%m-%d"), "\n")
    cat("Max: ", format(date_range[2], "%Y-%m-%d"), "\n")
    
    # Create Bar Chart for Date Distribution
    date_counts <- table(format(data[[col_name]], "%Y-%m"))
    # barplot(
    #   date_counts,
    #   main = paste("Date Distribution -", col_name),
    #   xlab = "Month-Year",
    #   ylab = "Count",
    #   col = "#C3A0E8"
    # )
    # Check for Missing Months
    if (any(!is.na(data[[col_name]]))) {
      # Generate a sequence of months starting from the second minimum date
      second_min_date <- sorted_dates[2]
      all_months <-
        seq(second_min_date, max(data[[col_name]], na.rm = TRUE), by = "month")
      
      # Count occurrences for each month
      all_month_counts <- table(format(all_months, "%Y-%m"))
      
      # Identify missing months
      missing_months <-
        setdiff(names(all_month_counts), names(date_counts))
      
      # Print missing months
      cat(
        "Missing months: ",
        ifelse(
          length(missing_months) > 0,
          paste(missing_months, collapse = ", "),
          "No missing months in the date range."
        ),
        "\n"
      )
      
      # Calculate and Print the Total Number of Missing Months
      total_missing_months <- length(missing_months)
      cat("Total number of missing months: ",
          total_missing_months,
          "\n")
    } else {
      cat("No valid dates in the column.\n")
    }
  }
  
  else if (col_type %in% c("POSIXct", "POSIXt")) {
    # Calculate and Print Date Range
    date_range <- range(data[[col_name]], na.rm = TRUE)
    sorted_dates <- sort(unique(data[[col_name]]))
    
    cat("Min: ", format(sorted_dates[2], "%Y-%m-%d %H:%M:%S"), "\n")
    cat("Max: ", format(date_range[2], "%Y-%m-%d %H:%M:%S"), "\n")
    
    # Calculate and Print Average
    avg_time <- mean(as.numeric(data[[col_name]]), na.rm = TRUE)
    cat("Average: ", format(
      as.POSIXct(avg_time, origin = "1970-01-01"),
      "%Y-%m-%d %H:%M:%S"
    ), "\n")
    
    # Check for Impossible Times
    impossible_times <-
      data[[col_name]][data[[col_name]] < as.POSIXct("1970-01-01", tz = "UTC") |
                         data[[col_name]] > Sys.time()]
    if (length(impossible_times) > 0) {
      cat("Impossible times found:\n")
      print(impossible_times)
    } else {
      cat("No impossible times found.\n")
    }
  }
  
  else {
    cat("Column type not recognized: ", col_type, "\n")
  }
  cat("------------------------------------------------------------------------\n")
}


# Print the map
my_map


end_time <- Sys.time()
print(paste("End time:", end_time))

print(start_time - end_time)