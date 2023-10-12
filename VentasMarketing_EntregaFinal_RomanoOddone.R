
##--------------------------- MARKETING AND SALES ANALYSIS

#---------------------------- Clear the global environment
rm(list = ls())
#---------------------------- Load required libraries
library(caret)
library(stringi)
library(ggplot2)
library(gridExtra)
library(reshape2)

#-----------------------------#0. Functions------------------------------------------------------------------------------------------------
# USED IN POINT #1
preprocess_data <- function(file_path) {
  # Read the CSV data
  data <- read.csv(file_path, sep = "," )
  
  # Convert "Precio" to a factor with custom labels
  data$Precio <- factor(data$Precio, levels = c("500", "750", "1000"), labels = c("Price500", "Price750", "Price1000"))
  
  # Specify the columns to one-hot encode
  columns_to_encode <- c("SeguridadDatos", "TiempoEntregaValor", "MetodologíaSeguimiento", "Precio")
  
  # Create dummy variables with explicit levels
  dummy_data <- dummyVars(~ ., data = data[, columns_to_encode], levelsOnly = TRUE)
  
  # Apply the transformation to your original data
  encoded_data <- predict(dummy_data, newdata = data[, columns_to_encode])
  
  # Combine the encoded columns with the original data
  final_data <- cbind(data, encoded_data)
  
  # Use the subset() function to exclude the specified columns
  final_data <- final_data[, !(names(final_data) %in% columns_to_encode)]
  
  # Remove accents from column names without removing the words
  colnames(final_data) <- stri_trans_general(colnames(final_data), "Latin-ASCII")
  
  # Rename specific columns
  colnames(final_data) <- gsub("<.*", "", gsub("\\(", "", colnames(final_data)))
  
  return(final_data)
}

create_subdataset <- function(data, id_persona) {
  # Subset the data for the specified IdPersona
  subdata <- subset(data, IdPersona == id_persona)
  
  # Remove the IdPersona column
  subdata <- subset(subdata, select = -IdPersona)
  
  return(subdata)
}

reorder_columns <- function(data, column_order) {
  # Reorder columns according to the specified order
  data <- data[, column_order]
  return(data)
}

# Function to run linear regression for all IdPersona and store results
run_linear_regression_for_all <- function(data) {
  # Get unique IdPersona values
  unique_ids <- unique(data$IdPersona)
  
  # Initialize a list to store regression summaries
  regression_summaries <- list()
  
  # Iterate through each unique IdPersona
  for (id in unique_ids) {
    # Create a subdataset for the current IdPersona
    subdataset <- create_subdataset(data, id)
    
    # Run a linear regression model
    linear_model <- lm(Preferencia ~ ., data = subdataset)
    
    # Store the summary in the list
    regression_summaries[[as.character(id)]] <- summary(linear_model)
  }
  
  return(regression_summaries)
}

# Function to print all regression results from the list
print_regression_results <- function(regression_results) {
  for (id in names(regression_results)) {
    cat("Regression Results for IdPersona:", id, "\n")
    print(regression_results[[id]])
    cat("\n")
  }
}

# USED IN POINT #2
# Function to calculate attribute importance for a given regression
calculate_attribute_importance <- function(regression_results) {
  # Extract the coefficients
  coeffs <- as.vector(regression_results$coefficients[, 1])
  
  # Define the levels and attributes
  levels <- c("Intercept", "SeguridadDatosAlta", "SeguridadDatosEstandar", "TiempoEntregaValorRapido", "TiempoEntregaValorMedio", "TiempoEntregaValorLento",
              "MetodologiaSeguimientoActiva", "MetodologiaSeguimientoRegular", "MetodologiaSeguimientoPasIva", "Price500", "Price750", "Price1000")
  attributes <- c("Intercept", rep(c("SeguridadDatos"), times = 2), rep(c("TiempoEntregaValor"), times = 3), 
                  rep(c("MetodologiaSeguimiento"), times = 3), rep(c("Price"), times = 3))
  
  # Create the part-worth utilities dataframe
  pw_ut <- c(coeffs[1:2], 0, coeffs[3:4], 0, coeffs[5:6], 0, coeffs[7:8], 0)
  pw_ut_df <- data.frame(Variable = attributes, Levels = levels, pw_ut)
  
  # Create a list to store the subset dataframes for each attribute
  attribute_data_list <- list()
  
  # Get the subset of the dataframe for each attribute
  attribute_ranges <- data.frame()
  for (attribute in unique(attributes)) {
    cell <- subset(pw_ut_df, pw_ut_df$Variable == attribute)
    range <- max(cell$pw_ut) - min(cell$pw_ut)
    attribute_ranges <- rbind(attribute_ranges, data.frame(Attribute = attribute, Range = range))
    attribute_data_list[[attribute]] <- cell
  }
  
  # Calculate the total range
  total_range <- sum(attribute_ranges$Range)
  
  # Calculate relative importance for each attribute
  attribute_importance <- data.frame()
  for (i in 1:length(attribute_ranges$Attribute)) {
    attribute <- attribute_ranges$Attribute[i]
    range <- attribute_ranges$Range[i]
    importance <- range / total_range
    attribute_importance <- rbind(attribute_importance, data.frame(Attribute = attribute, Importance = importance))
  }
  
  attribute_importance <- attribute_importance[attribute_importance$Attribute != "Intercept", ]
  
  return(list(attribute_importance = attribute_importance, attribute_data_list = attribute_data_list))
}

#-----------------------------#1. Linear Regressions to estimate the partial values of each survey participant------------

# Set the path where the raw files are located
file_path <- "/Users/santiagoromano/Documents/Mim/VentasMarketing/RespuestasFormulario.csv"

# Call the pre processing function
processed_data <- preprocess_data(file_path)

names(processed_data)

column_order <- c(
  "IdPersona", "Preferencia", "SeguridadDatosAlta", "SeguridadDatosEstandar",
  "TiempoEntregaValorRapido", "TiempoEntregaValorMedio", "TiempoEntregaValorLento",
  "MetodologiaSeguimientoActiva", "MetodologiaSeguimientoRegular", "MetodologiaSeguimientoPasIva",
   "Price500",  "Price750","Price1000"
)

# Call the reorder_columns function in order to set SeguridadDatosEstandar, TiempoEntregaValorLento, MetodologiaSeguimientoPasIva, Price1000 as the reference categories. 
processed_data <- reorder_columns(processed_data, column_order)

# Call the function to run linear regression for all IdPersona
regression_results <- run_linear_regression_for_all(processed_data)

# Call the function to print all regression results
print_regression_results(regression_results)

# To access a specific regression, select the index as follows:
regression_results[[15]]

#-----------------------------#2. Attributes importance calculation for each survey participant------------------------
# Create a list to store attribute importance results for each regression
attribute_importance_list <- list()

# Create a list to store plots for each regression
attributes_plot_list <- list()

# Loop through each regression in the regression_results list
for (i in 1:length(regression_results)) {
  # The function calculates attribute importance for a given regression
  result <- calculate_attribute_importance(regression_results[[i]])
  attribute_importance <- result$attribute_importance
  attribute_importance_list[[i]] <- attribute_importance
  
  # Create the plot
  plot <- ggplot(attribute_importance, aes(x = Attribute, y = Importance)) +
    geom_bar(stat = "identity") +
    ggtitle(paste("Relative importance of attributes - Regression", i)) + 
    theme(axis.text.x = element_text(size = 10))
  
  # Append the plot to the list
  attributes_plot_list[[i]] <- plot
  #print(attributes_plot_list[[i]])
}


# To access a specific plot, select the index as follows:
attributes_plot_list[[15]]
attribute_importance_list[[15]]

#-----------------------------#3. Partial values associated with the price of each respondent------------
# Create a list to store attribute importance results for each regression
attribute_importance_list <- list()

# Create a list to store cellPrice data for each regression
cellPrice_list <- list()

# Create a list to store plots for each regression
price_plot_list <- list()

# Loop through each regression in the regression_results list
for (i in 1:length(regression_results)) {
  # Calculate attribute importance and store data
  result <- calculate_attribute_importance(regression_results[[i]])
  attribute_importance <- result$attribute_importance
  attribute_importance_list[[i]] <- attribute_importance
  
  # Extract cellPrice data
  cellPrice <- result$attribute_data_list[["Price"]]
  cellPrice_list[[i]] <- cellPrice
  
  # Modify the order of levels in cellPrice to see the impact of reducing the price 
  cellPrice$Levels <- factor(cellPrice$Levels, levels = c("Price1000", "Price750", "Price500"))
  
  # Create the plot for cellPrice data
  plot <- ggplot(data = cellPrice, aes(x = Levels, y = pw_ut, group = 1)) +
    geom_line() +
    geom_point() +
    ggtitle(paste("Valores parciales asociados al precio - IdPersona: ", i)) +
    ylab("Part-Worth Utilities") + 
    theme(axis.text.x = element_text(size = 10)) 
  # Append the plot to the list
  price_plot_list[[i]] <- plot
}

# To access a specific plot, select the index as follows:
price_plot_list[[15]]


#-----------------------------#4. How much are consumers willing to pay for changes in the most important attribute?------------
lowPrice <- 500
mediumPrice <- 750
highPrice <- 1000

attribute_data_list <- list()

# Loop through each regression in the regression_results list
for (i in 1:length(regression_results)) {

  result <- calculate_attribute_importance(regression_results[[i]])
  attribute_data <- result$attribute_data_list
  attribute_data_list[[i]] <- attribute_data
}

# Create a list to store the results for each client
results_list <- list()

# Loop through each client
for (i in 1:length(attribute_importance_list)) {
  # Get the attribute importance data for the current client
  client_attribute_importance <- attribute_importance_list[[i]]
  
  b <- attribute_data_list[[i]]
  # Find the attribute with the highest importance value
  max_importance <- max(client_attribute_importance$Importance)
  preferred_attribute <- client_attribute_importance$Attribute[client_attribute_importance$Importance == max_importance]
  
  # Check if the preferred attribute is "Price"
  if (preferred_attribute == "Price") {
    # Exclude the highest importance value
    client_attribute_importance <- client_attribute_importance[client_attribute_importance$Attribute != "Price", ]
    
    # Find the attribute with the second highest importance value
    second_max_importance <- max(client_attribute_importance$Importance)
    preferred_attribute <- client_attribute_importance$Attribute[client_attribute_importance$Importance == second_max_importance]
  }
  
  # Extract the relevant attribute data for the preferred attribute
  preferred_attribute_data <- b[[preferred_attribute]]
  
  # Determine the levels for the preferred and other attributes
  highest_level <- preferred_attribute_data$Levels[which.max(preferred_attribute_data$pw_ut)]
  lowest_level <- preferred_attribute_data$Levels[which.min(preferred_attribute_data$pw_ut)]
  
  # Calculate attribute_ut_range for the preferred attribute
  atribute_ut_range <- preferred_attribute_data$pw_ut[preferred_attribute_data$Levels == highest_level] -
    preferred_attribute_data$pw_ut[preferred_attribute_data$Levels == lowest_level]
  
  # Calculate the willingness to pay for the preferred attribute
  price_range <- highPrice - lowPrice
  price_ut_range <- b$Price$pw_ut[which.max(b$Price$pw_ut)] - 
    b$Price$pw_ut[which.min(b$Price$pw_ut)]
  mv <- price_range / price_ut_range
  wtp <- mv * atribute_ut_range
  
  # Prepare the description for the change
  change_description <- paste(
    "Changing from the lowest to the highest value of", preferred_attribute,
    "provides a utility of", round(atribute_ut_range, 2),  # Round to 2 decimal places
    "and the willingness to pay for it will be", round(wtp, 2), "dollars"  # Round to 2 decimal places
  )
  
  # Store the results in a data frame
  client_results <- data.frame(
    Client = i,
    PreferredAttribute = as.character(preferred_attribute),
    Utility = round(atribute_ut_range, 2),  # Round utility to 2 decimal places
    WTP = round(wtp, 2),  # Round WTP to 2 decimal places
    ChangeDescription = change_description  # Add the change description column
  )
  
  # Append the results to the list
  results_list[[i]] <- client_results
}

# Combine the results for all clients into a single data frame
all_results <- do.call(rbind, results_list)

# Print the results
print(all_results)


#-----------------------------#5. Segment respondents based on the preferences obtained through regression.----

# Create a list to store the coefficients for each IdPersona
coefficients_list <- list()

# Extract coefficients from regression results
for (i in 1:length(regression_results)) {
  # Extract coefficients from regression results for IdPersona i
  coefficients <- coef(regression_results[[i]])
  coefficients_list[[i]] <- coefficients
}

# Initialize an empty dataframe
coefficient_df <- data.frame()

# Extract the "Estimate" values for each person
for (i in 1:length(coefficients_list)) {
  # Extract coefficients for IdPersona i
  coefficients <- coefficients_list[[i]]
  
  # Extract the "Estimate" values for the coefficients of interest
  estimate_values <- coefficients[rownames(coefficients) %in% c("(Intercept)", "SeguridadDatosAlta", 
                                                                "TiempoEntregaValorRapido", 
                                                                "TiempoEntregaValorMedio", 
                                                                "MetodologiaSeguimientoActiva", 
                                                                "MetodologiaSeguimientoRegular", 
                                                                "Price500", "Price750"), "Estimate"]
  
  # Create a dataframe for the current person and transpose it
  person_df <- data.frame(t(estimate_values))
  
  # Rename the columns based on the coefficients of interest
  colnames(person_df) <- c("(Intercept)", "SeguridadDatosAlta", "TiempoEntregaValorRapido", 
                           "TiempoEntregaValorMedio", "MetodologiaSeguimientoActiva", 
                           "MetodologiaSeguimientoRegular", "Price500", "Price750")
  
  # Bind the current person's dataframe to the main dataframe
  coefficient_df <- rbind(coefficient_df, person_df)
}

coefficient_df

# Reset row names
row.names(coefficient_df) <- NULL

# Print the resulting dataframe
print(coefficient_df)

# Standardize the data (important for k-means)
scaled_data <- scale(coefficient_df)

print(scaled_data)

# Determine the ideal number of clusters using the Elbow method
inertia_values <- vector()
k_range <- 1:10 

for (k in k_range) {
  if (k < nrow(scaled_data)) {  # Ensure there are more data points than clusters
    kmeans_model <- kmeans(scaled_data, centers = k)
    inertia_values <- c(inertia_values, kmeans_model$tot.withinss)
  }
}

# Plot the Elbow curve
plot(k_range[1:length(inertia_values)], inertia_values, type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of Clusters (k)", ylab = "Inertia",
     main = "Elbow Method for Optimal k")

# Perform k-means clustering with 4 clusters
k <- 4
kmeans_model <- kmeans(scaled_data, centers = k)

# Add cluster assignments to the coefficient_df dataframe
coefficient_df$Cluster <- kmeans_model$cluster

# Print the updated dataframe
print(coefficient_df)

# Calculate the mean values of each attribute within each cluster
cluster_means <- aggregate(. ~ Cluster, data = coefficient_df, FUN = mean)

# Print the cluster means
print(cluster_means)

# Create a bar plot to visualize attribute importance within each cluster
melted_cluster_means <- melt(cluster_means, id.vars = "Cluster")

# Adjust the bar width
ggplot(melted_cluster_means, aes(x = Cluster, y = value, fill = variable)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8)) +  
  labs(x = "Cluster", y = "Mean Value", fill = "Attribute") +
  ggtitle("Attribute Importance by Cluster")


#-----------------------------#6. Analyzing two more competitive options.----

# Create a data frame to store the results
results_df <- data.frame(
  AttributeCombination = character(0),
  Utility_x = numeric(0),
  Utility_y = numeric(0),
  SelectedService = character(0)  # Add the new column
)

# Loop through each attribute combination
for (i in 1:length(regression_results)) {
  # Calculate attribute importance and store data
  result <- calculate_attribute_importance(regression_results[[i]])
  
  # Calculate utilities for competitors x and y
  utility_x <- sum(
    result$attribute_data_list$Intercept$pw_ut +
      result$attribute_data_list$SeguridadDatos$pw_ut[result$attribute_data_list$SeguridadDatos$Levels == "SeguridadDatosEstandar"] +
      result$attribute_data_list$TiempoEntregaValor$pw_ut[result$attribute_data_list$TiempoEntregaValor$Levels == "TiempoEntregaValorRapido"] +
      result$attribute_data_list$MetodologiaSeguimiento$pw_ut[result$attribute_data_list$MetodologiaSeguimiento$Levels == "MetodologiaSeguimientoActiva"] +
      result$attribute_data_list$Price$pw_ut[result$attribute_data_list$Price$Levels == "Price1000"]
  )
  
  utility_y <- sum(
    result$attribute_data_list$Intercept$pw_ut +
      result$attribute_data_list$SeguridadDatos$pw_ut[result$attribute_data_list$SeguridadDatos$Levels == "SeguridadDatosAlta"] +
      result$attribute_data_list$TiempoEntregaValor$pw_ut[result$attribute_data_list$TiempoEntregaValor$Levels == "TiempoEntregaValorMedio"] +
      result$attribute_data_list$MetodologiaSeguimiento$pw_ut[result$attribute_data_list$MetodologiaSeguimiento$Levels == "MetodologiaSeguimientoRegular"] +
      result$attribute_data_list$Price$pw_ut[result$attribute_data_list$Price$Levels == "Price750"]
  )
  
  
  # Determine the selected service
  selected_service <- ifelse(utility_x > utility_y, "x", "y")
  
  # Add the results to the data frame
  results_df <- rbind(results_df, data.frame(
    AttributeCombination = paste("Participant", i),
    Utility_x = utility_x,
    Utility_y = utility_y,
    SelectedService = selected_service
  ))
}

# Print the results data frame
print(results_df)

# Calculate the total count of 'x' and 'y' in the 'SelectedService' column
x_count <- sum(results_df$SelectedService == "x")
y_count <- sum(results_df$SelectedService == "y")

# Calculate the total count of observations
total_count <- nrow(results_df)

# Calculate the percentages
percentage_x <- (x_count / total_count) * 100
percentage_y <- (y_count / total_count) * 100

cat("Percentage of 'x':", percentage_x, "%\n")
cat("Percentage of 'y':", percentage_y, "%\n")



# Create a data frame for the pie chart
pie_data <- data.frame(
  Service = c("x", "y"),
  Percentage = c(percentage_x, percentage_y)
)

# Create the pie chart using ggplot2
ggplot(data = pie_data, aes(x = "", y = Percentage, fill = Service)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar(theta = "y") +
  labs(title = "SelectedService Percentages") +
  theme_minimal() +
  theme(legend.position = "bottom") +
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), position = position_stack(vjust = 0.5))


## ---------------------------THE END. THANKS IN ADVANCE!------

