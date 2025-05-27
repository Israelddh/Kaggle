
# Amazon Best Sellers Analysis: Software Category
# Author: Israel David Duarte Herrera
# Contact: www.linkedin.com/in/israel-duarte
# GitHub: https://github.com/Israelddh
# Date: 2025
# Description:
#   Exploratory Data Analysis and Clustering of Amazon software products
#   to uncover pricing, review trends, and product groupings across countries.
#
# Project: Data Science Portfolio - Amazon Software Best Sellers
# Purpose:
#   Demonstrate data cleaning, visualization, and unsupervised learning skills
#   using real-world e-commerce dataset.
#
# Tools:
#   R (readr, dplyr, ggplot2, visdat)
#
# Notes:
#   This script performs data wrangling, exploratory analysis, and k-means clustering.


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
# Observation: The majority of products have high ratings (4 or 5 stars),
# indicating a positive customer perception overall.
# There are fewer products with mid-range ratings (2-3 stars).
ggplot(data_clean, aes(x = product_star_rating)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Product Star Ratings", x = "Star Rating", y = "Count")


# ================================
# Check and plot distribution of number of reviews
# ================================
missing_num_ratings <- sum(is.na(data_clean$product_num_ratings))
cat("Missing number of reviews: ", missing_num_ratings, "\n")

# Key percentiles to describe distribution and tail
quantiles <- quantile(data_clean$product_num_ratings, probs = c(0.75, 0.99))
print(quantiles)

# Plot histogram of number of reviews per product
# Observation:
# Most products have fewer than 1,000 reviews (75th percentile = 956),
# but a small number of products have very high review counts (99th percentile = 15,762),
# demonstrating a typical long-tail distribution common in e-commerce data.
# No missing values in 'product_num_ratings', so the feature is complete.

ggplot(data_clean, aes(x = product_num_ratings)) +
  geom_histogram(binwidth = 500, fill = "orange", color = "black", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Number of Reviews", x = "Number of Reviews", y = "Count")



# ================================
# Scatter plot: Price vs. Number of Reviews
# ================================
# Calculate correlation
correlation <- cor(data_clean$product_price_clean, data_clean$product_num_ratings, use = "complete.obs")
cat("Correlation between price and number of reviews: ", correlation, "\n")

# Plot relationship between product price and number of reviews
# Observation:
#   Prices range widely, from $0.01 up to over $230,000.
#   Most products (75%) cost below ~$3,800, but a few extreme outliers pull the max very high.
#   The correlation between price and number of reviews is weakly negative (~ -0.06),
#   suggesting that more expensive products do not necessarily have more reviews.
#   This scatter plot helps visualize whether popular products tend to cluster in a certain price range.
ggplot(data_clean, aes(x = product_price_clean, y = product_num_ratings)) +
  geom_point(alpha = 0.5, color = "darkgreen") +
  theme_minimal() +
  labs(title = "Price vs. Number of Reviews", x = "Price ($)", y = "Number of Reviews")

# ================================
# Identify top 10 products by number of reviews
# ================================
# Select top 10 products with highest number of reviews
top_10_reviews <- data_clean %>%
  arrange(desc(product_num_ratings)) %>%
  head(10)

# Plot top 10 products by number of reviews
# Observation:
#   The top products are dominated by Microsoft 365 and McAfee Antivirus,
#   each with exceptionally high review counts (over 31,000 and 16,800 respectively).
#   This highlights how a few flagship products strongly stand out in popularity,
#   compared to the rest of the dataset.
ggplot(top_10_reviews, aes(x = reorder(product_title, product_num_ratings), y = product_num_ratings)) +
  geom_bar(stat = "identity", fill = "coral") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 10 Products by Number of Reviews", x = "Product Title", y = "Number of Reviews")


# ================================
# Prepare data for clustering
# ================================
# Select relevant numeric features: price and number of reviews
clustering_data <- data_clean %>%
  select(product_price_clean, product_num_ratings)

# Filter rows with complete and finite values (exclude NAs or infinite)
valid_rows <- complete.cases(clustering_data) & is.finite(rowSums(clustering_data))
clustering_data_clean <- clustering_data[valid_rows, ]

# Print number of rows before and after cleaning to verify data quality
cat("Rows before cleaning: ", nrow(clustering_data), "\n")
cat("Rows after cleaning: ", nrow(clustering_data_clean), "\n")

# Observation:
#   This step ensures we only pass clean, usable numeric data into the clustering algorithm.
#   Rows with missing or non-finite values (e.g., NA or Inf) are excluded,
#   resulting in a dataset ready for meaningful k-means clustering.


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


# Status: 🚧 Work in Progress