# Fraud Guard: Credit Card Fraud Detection Using Machine Learning

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Fraud Guard is a machine learning-powered platform designed to detect fraudulent credit card transactions. Built using R and Shiny, it offers a combination of predictive modeling, interactive visualizations, and a secure user interface to help identify and analyze fraudulent patterns efficiently.

## Features

- **Secure Login:** Google OAuth 2.0 for user authentication.
- **Dataset Upload:** Upload CSV datasets with flexible configurations.
- **Machine Learning:** Train Random Forest models for fraud prediction.
- **Interactive Visualizations:**
  - 2D scatter, bar, and line plots.
  - 3D scatter, line, and mesh visualizations.
- **Performance Metrics:** Analyze accuracy, fraud rate, and transaction counts.
- **User-Friendly Navigation:** Multi-tab interface for seamless transitions between features.

## Technologies Used

- **Languages:** R
- **Framework:** Shiny
- **Machine Learning Library:** Random Forest
- **Visualization:** Plotly, ggplot2
- **Authentication:** Google OAuth 2.0
- **Other Libraries:** caret, DT, shinythemes, shinyWidgets

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/fraud-guard.git
   cd fraud-guard
Install the required R libraries:
install.packages(c("shiny", "shinydashboard", "shinyWidgets", "shinythemes", "plotly", 
                   "randomForest", "DT", "httr", "jsonlite", "httpuv", "bslib", "caret", "ggplot2", "reshape2"))
Launch the application:
shiny::runApp('Fraud-Guard.R')
Usage
Open the application in your browser after launching it.
Log in using your Google account.
Upload a dataset in CSV format.
Train the machine learning model to detect fraudulent transactions.
Explore transaction data using 2D and 3D visualizations.
View dataset summaries and model performance metrics.
Example Dataset Structure:
transaction_id,amount,time,location,fraud
1,500.00,2023-05-01,New York,0
2,1200.50,2023-05-02,Los Angeles,1
3,75.25,2023-05-03,Chicago,0
Project Structure
Fraud-Guard.R: The main R script for the Shiny application.
data/ (optional): Sample datasets for testing.
assets/ (optional): Static files such as logos or images.
Contributing
Contributions are welcome! Please fork the repository and submit a pull request with your enhancements or bug fixes.

License
This project is licensed under the MIT License. See the LICENSE file for more details.
Let me know if you want further modifications or additional sections for your README.
