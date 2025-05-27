# Amazon Best Sellers Analysis – Software Category  
**Status:** 🚧 Work in Progress

## 📌 Overview  
This project analyzes Amazon Best Sellers data focused on software products across multiple countries. The goal is to uncover interesting patterns about product popularity, pricing, and customer engagement using clear visualizations and unsupervised learning techniques.

The dataset includes key features such as product price, average star rating, number of reviews, and sales rank, all collected via the Amazon API.

## 🎯 Objectives  
- Identify top-performing software products based on customer reviews and ratings.  
- Analyze pricing and review trends across different countries.  
- Apply clustering methods (e.g., k-means) to group products by price and review count.  
- Visualize insights with intuitive, informative plots.

## 📊 Dataset  
Filename: `amazon_best_sellers_software.csv`  

**Key Features:**  
- `product_title`: Software product name  
- `product_price`: Price (in local currency)  
- `product_star_rating`: Average customer rating  
- `product_num_ratings`: Number of reviews  
- `rank`: Best Seller rank  
- `country`: Country where the product is ranked

## 🛠️ Tools & Technologies  
- **R:** Data cleaning, manipulation, exploratory analysis, clustering  
- **ggplot2:** Data visualization  
- **dplyr:** Data manipulation  
- **stats (kmeans):** Clustering analysis  

## 📁 How to Reproduce  
1. Load the dataset `amazon_best_sellers_software.csv`.  
2. Run the script `01_Amazon_best_seller_software.R`.  
3. The script performs exploratory data analysis, visualizations, and clustering.

## 📈 Potential Applications  
- Market and competitor analysis in e-commerce.  
- Data-driven pricing strategy design.  
- Identifying emerging trends in the software product category.

---

This project demonstrates skills in data wrangling, exploratory data analysis, effective visualization, and unsupervised learning applied to a real-world e-commerce dataset.

