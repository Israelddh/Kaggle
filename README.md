# Amazon Best Sellers Analysis - Software Category
**Status**: 🚧 *Work in Progress*

## 📌 Overview
This project explores Amazon Best Sellers data focused on software products across multiple countries. It aims to uncover insights about product popularity, pricing patterns, and customer engagement using data visualization and unsupervised learning techniques.

The dataset includes key features such as product price, star rating, number of reviews, and sales rank, and was collected via the Amazon API.

## 🎯 Objectives
- Identify top-performing software products based on customer reviews and ratings
- Analyze pricing and review trends across different countries
- Apply clustering techniques (e.g., k-means) to group products by price and review count
- Visualize insights using clear and informative plots (bar charts, scatter plots with clusters)

## 📊 Dataset Summary
**Filename**: `amazon_best_sellers_software.csv`

**Key Features**:
- `product_title`: Software product name
- `product_price`: Price (in local currency)
- `product_star_rating`: Average customer rating
- `product_num_ratings`: Number of reviews
- `rank`: Best Seller rank
- `country`: Country where product is ranked

## 🛠️ Tools & Technologies
- **R**: Data cleaning, visualization, clustering
- **ggplot2**: Data visualization
- **dplyr**: Data manipulation
- **stats (kmeans)**: Clustering analysis

## 📁 How to Reproduce
- Load the data: `amazon_best_sellers_software.csv`
- Run the analysis in: `01_Amazon_best_seller_software.R`
- The script performs EDA, visualizations, and clustering

## 📈 Potential Applications
- Market and competitor analysis in e-commerce
- Data-driven pricing strategy design
- Identifying emerging product trends in the software category

---

*This project showcases data wrangling, exploratory analysis, and unsupervised learning skills applied to a real-world dataset from e-commerce.*

