# Amazon Best Sellers Analysis: Software Category
# Author: Israel David Duarte Herrera
# Description: Exploratory analysis and clustering of Amazon software products 
# to uncover pricing and review trends across countries.

# ================================
# Load required libraries
# ================================
library(readr)      # For reading CSV files
library(dplyr)      # For data manipulation
library(ggplot2)    # For data visualization
library(visdat)     # For visualizing missing data patterns

# ================================
# Load dataset
# ================================
data <- read.csv("01_Amazon_best_seller_softwares/best_sellers_data2.csv", stringsAsFactors = FALSE)

# Inspect data structure and summary statistics
str(data)
head(data)
summary(data)

# ================================
# Clean and convert product price
# ================================
# Remove any non-numeric characters from price strings (e.g., $, commas)
unique(data$product_price)  # Check unique price formats before cleaning
data$product_price_clean <- gsub("[^0-9\\.]", "", data$product_price)
data$product_price_clean <- as.numeric(data$product_price_clean)

# Optional: Check how many prices could not be converted (NAs)
sum(is.na(data$product_price_clean))

# ================================
# Visualize missing data
# ================================
vis_miss(data)

# ================================
# Handle missing star ratings
# ================================
# Count and percentage of missing 'product_star_rating'
missing_star_count <- sum(is.na(data$product_star_rating))
missing_star_pct <- round(missing_star_count / nrow(data) * 100, 2)
cat("Missing star ratings: ", missing_star_count, " (", missing_star_pct, "%)\n")

# Check if missing star ratings correspond to products with missing or zero reviews
summary(data$product_num_ratings[is.na(data$product_star_rating)])

# Exclude products missing star ratings or number of reviews from satisfaction analyses
data_clean <- data %>% 
  filter(!is.na(product_star_rating), !is.na(product_num_ratings))

cat("Remaining rows after filtering: ", nrow(data_clean), "\n")

# ================================
# Plot distribution of product star ratings
# ================================
ggplot(data_clean, aes(x = product_star_rating)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Product Star Ratings", x = "Star Rating", y = "Count")

# ================================
# Check and plot distribution of number of reviews
# ================================
missing_num_ratings <- sum(is.na(data_clean$product_num_ratings))
cat("Missing number of reviews: ", missing_num_ratings, "\n")

ggplot(data_clean, aes(x = product_num_ratings)) +
  geom_histogram(binwidth = 500, fill = "orange", color = "black", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Number of Reviews", x = "Number of Reviews", y = "Count")

# ================================
# Scatter plot: Price vs. Number of Reviews
# ================================
ggplot(data_clean, aes(x = product_price_clean, y = product_num_ratings)) +
  geom_point(alpha = 0.5, color = "darkgreen") +
  theme_minimal() +
  labs(title = "Price vs. Number of Reviews", x = "Price ($)", y = "Number of Reviews")

# ================================
# Identify top 10 products by number of reviews
# ================================
top_10_reviews <- data_clean %>%
  arrange(desc(product_num_ratings)) %>%
  head(10)

# Plot top 10 products by number of reviews
ggplot(top_10_reviews, aes(x = reorder(product_title, product_num_ratings), y = product_num_ratings)) +
  geom_bar(stat = "identity", fill = "coral") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 10 Products by Number of Reviews", x = "Product Title", y = "Number of Reviews")

# ================================
# Prepare data for clustering
# ================================
clustering_data <- data_clean %>%
  select(product_price_clean, product_num_ratings)

# Filter rows with complete and finite values
valid_rows <- complete.cases(clustering_data) & is.finite(rowSums(clustering_data))
clustering_data_clean <- clustering_data[valid_rows, ]

# ================================
# Perform k-means clustering with 3 clusters
# ================================
set.seed(123)  # For reproducibility
kmeans_result <- kmeans(clustering_data_clean, centers = 3)

# Assign cluster labels back to cleaned data
data_clean$cluster <- NA
data_clean$cluster[valid_rows] <- kmeans_result$cluster

# ================================
# Visualize clusters: Price vs. Number of Reviews
# ================================
ggplot(data_clean[!is.na(data_clean$cluster), ], aes(x = product_price_clean, y = product_num_ratings, color = factor(cluster))) +
  geom_point(alpha = 0.6) +
  theme_minimal() +
  labs(
    title = "Product Clusters by Price and Number of Reviews",
    x = "Price ($)",
    y = "Number of Reviews",
    color = "Cluster"
  )
