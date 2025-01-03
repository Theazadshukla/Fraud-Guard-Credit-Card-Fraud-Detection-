# Fraud Guard 🛡️ 

## Overview
Fraud Guard is an advanced fraud detection platform built with R Shiny that uses machine learning to identify and prevent fraudulent transactions in real-time. The application features a modern, responsive UI with interactive visualizations and secure authentication.

![Fraud Guard](https://static.vecteezy.com/system/resources/previews/032/410/187/large_2x/fraud-thick-line-filled-dark-colors-icons-for-personal-and-commercial-use-free-vector.jpg)

## Features
- 🔒 **Secure Authentication**: Google OAuth integration
- 📊 **Interactive Data Analysis**: Real-time data visualization and filtering
- 🤖 **Machine Learning**: Random Forest model for fraud detection
- 📈 **Advanced Analytics**: Performance metrics and transaction analysis
- 🎨 **Modern UI/UX**: Responsive design with animations

## Tech Stack
- R Shiny
- randomForest
- Plotly
- Google OAuth 2.0
- DT (DataTables)
- shinydashboard
- ggplot2

## Prerequisites
- R (>= 4.0.0)
- RStudio (recommended)

## Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/fraud-guard.git
cd fraud-guard
```

2. **Install required R packages**
```R
install.packages(c(
    "shiny",
    "shinydashboard",
    "shinyWidgets",
    "shinythemes",
    "plotly",
    "randomForest",
    "DT",
    "httr",
    "jsonlite",
    "httpuv",
    "bslib",
    "caret",
    "ggplot2",
    "reshape2"
))
```

3. **Configure Google OAuth**
- Update `google_client_id` and `google_client_secret` in the code
- Set up redirect URIs in Google Cloud Console

4. **Run the application**
```R
shiny::runApp()
```

## Usage

### Data Format
Your CSV file should include:
- Header row
- 'fraud' as the target variable (last column)
- Numeric columns for analysis

Example:
```csv
transaction_id,amount,time,location,fraud
1,500.00,2023-05-01,New York,0
2,1200.50,2023-05-02,Los Angeles,1
```

### Features
1. **Data Upload**
   - Supports CSV format
   - Flexible configuration options
   - Data validation

2. **Fraud Detection**
   - Random Forest model training
   - Real-time predictions
   - Variable importance analysis

3. **Visualization**
   - 2D/3D interactive plots
   - Dynamic filtering
   - Performance metrics

## 🚀 Key Features

### Authentication
- Secure Google OAuth 2.0 integration
- Session management
- User profile display

### Analytics Dashboard
- Transaction overview
- Fraud rate tracking
- Model performance metrics

### Visualization Tools
- Interactive plots
- Real-time data filtering
- Custom chart options

## Contributing
Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/NewFeature`)
3. Commit changes (`git commit -m 'Add NewFeature'`)
4. Push to branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

## Team

### Core Developers
- **Project Lead**: Azad Shukla
- **UI Developer**: Aditya Alok
  - R Shiny UI/UX design and implementation
  - GitHub: [Aditya Alok](https://github.com/adityaalok)

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support
For support:
- Open an issue on GitHub
- Contact the development team
- Check documentation

---

## Acknowledgments
Special thanks to:
- Aditya Alok for UI/UX implementation
- The R Shiny community
- All contributors and testers
