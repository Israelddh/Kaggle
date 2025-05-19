
# E-commerce Market Analysis----

library(readxl)
library(readr)
library(visdat)
library(ggplot2)
library(tidyverse)


data <- read.csv("01_Amazon_best_seller_softwares/best_sellers_data2.csv", stringsAsFactors = FALSE)
View(data)

str(data)
head(data)

summary(data)

data$product_price <- as.numeric(gsub("\\$", "", data$product_price))

vis_miss(data)


# Check for any missing values in the 'product_star_rating' column
sum(is.na(data$product_star_rating))

# Plot the distribution of product ratings
ggplot(data, aes(x = product_star_rating)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Product Ratings", x = "Star Rating", y = "Count")

# Check for missing values in 'product_num_ratings' column
sum(is.na(data$product_num_ratings))

# Plot the distribution of number of reviews
ggplot(data, aes(x = product_num_ratings)) +
  geom_histogram(binwidth = 500, fill = "orange", color = "black", alpha = 0.7) +
  theme_minimal() +
  labs(title = "Distribution of Number of Reviews", x = "Number of Reviews", y = "Count")

# Visualize the relationship between price and number of reviews
ggplot(data, aes(x = product_price, y = product_num_ratings)) +
  geom_point(alpha = 0.5, color = "darkgreen") +
  theme_minimal() +
  labs(title = "Price vs. Number of Reviews", x = "Price ($)", y = "Number of Reviews")

# Analyze top 10 products by number of reviews
top_10_reviews <- data %>%
  arrange(desc(product_num_ratings)) %>%
  head(10)

# Show the top 10 products by number of reviews
top_10_reviews

# Plot top 10 products by number of reviews
ggplot(top_10_reviews, aes(x = reorder(product_title, product_num_ratings), y = product_num_ratings)) +
  geom_bar(stat = "identity", fill = "coral") +
  coord_flip() +
  theme_minimal() +
  labs(title = "Top 10 Products by Number of Reviews", x = "Product Title", y = "Number of Reviews")







# Select numeric variables for clustering
clustering_data <- data[, c("product_price", "product_num_ratings")]

# Find valid rows with complete and finite data
valid_rows <- which(complete.cases(clustering_data) & 
                      is.finite(rowSums(clustering_data)))

# Subset data for clustering
clustering_data_clean <- clustering_data[valid_rows, ]

# Perform k-means clustering
set.seed(123)
kmeans_result <- kmeans(clustering_data_clean, centers = 3)

# Initialize cluster column in original data
data$cluster <- NA

# Assign clusters only to valid rows
data$cluster[valid_rows] <- kmeans_result$cluster




# Visualize clusters: Price vs Number of Reviews colored by cluster
library(ggplot2)

ggplot(data[!is.na(data$cluster), ], aes(x = product_price, y = product_num_ratings, color = factor(cluster))) +
  geom_point(alpha = 0.6) +
  theme_minimal() +
  labs(
    title = "Product Clusters by Price and Number of Reviews",
    x = "Price ($)",
    y = "Number of Reviews",
    color = "Cluster"
  )

# Select top 10 products by number of reviews
top_10_reviews <- data[order(-data$product_num_ratings), ][1:10, ]

# Plot top 10 products by number of reviews
ggplot(top_10_reviews, aes(x = reorder(product_title, product_num_ratings), y = product_num_ratings)) +
  geom_bar(stat = "identity", fill = "coral") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Top 10 Products by Number of Reviews",
    x = "Product Title",
    y = "Number of Reviews"
  )


