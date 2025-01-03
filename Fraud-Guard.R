library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinythemes)
library(plotly)
library(randomForest)
library(DT)
library(httr)
library(jsonlite)
library(httpuv)
library(bslib)
library(caret)
library(ggplot2)
library(reshape2)
# Google OAuth Credentials
google_client_id <- "1094138545387-vhfn2vnrv5l5fvjp42h21gfl9o6bd7vt.apps.googleusercontent.com"
google_client_secret <- "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"

# Define OAuth Scopes
scopes <- c("https://www.googleapis.com/auth/userinfo.profile",
            "https://www.googleapis.com/auth/userinfo.email")

custom_css <- "@keyframes gradientBackground {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

@keyframes fraudGuardAnimation {
    0% { 
        opacity: 0.3; 
        transform: translateY(-30px) rotate(-5deg);
        color: rgba(0, 0, 139, 0.2);
        text-shadow: 
            0 0 5px rgba(135, 206, 250, 0.2), 
            0 0 15px rgba(135, 206, 250, 0.2),
            2px 2px 4px rgba(0,0,0,0.1);
    }
    50% { 
        opacity: 1; 
        transform: translateY(0) rotate(0deg);
        color: rgba(0, 0, 139, 0.9);
        text-shadow: 
            0 0 15px rgba(135, 206, 250, 0.6), 
            0 0 25px rgba(135, 206, 250, 0.8),
            3px 3px 6px rgba(0,0,0,0.2);
    }
    100% { 
        opacity: 0.3; 
        transform: translateY(30px) rotate(5deg);
        color: rgba(0, 0, 139, 0.2);
        text-shadow: 
            0 0 5px rgba(135, 206, 250, 0.2), 
            0 0 15px rgba(135, 206, 250, 0.2),
            2px 2px 4px rgba(0,0,0,0.1);
    }
}

@keyframes shieldPulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

@keyframes dataFlow {
    0% { 
        background-position: -200% 0;
    }
    100% { 
        background-position: 200% 0;
    }
}
@keyframes logoRotate {
    0% { transform: rotate(0deg) scale(1); }
    50% { transform: rotate(10deg) scale(1.1); }
    100% { transform: rotate(0deg) scale(1); }
}

@keyframes logoPulse {
    0%, 100% { transform: scale(1); }
    50% { transform: scale(1.05); }
}

.fraud-logo {
    animation: logoRotate 3s ease-in-out infinite, 
               logoPulse 2s ease-in-out infinite alternate;
    transition: all 0.3s ease;
}

.fraud-logo:hover {
    transform: scale(1.1) rotate(5deg);
    filter: brightness(1.1);
}
body {
    background: linear-gradient(135deg, #f0f4f8, #c3cfe2, #87CEFA, #1E90FF);
    background-size: 400% 400%;
    background-attachment: fixed;
    animation: gradientBackground 15s ease infinite;
    position: relative;
    font-family: 'Inter', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
}

#background-wrap {
    bottom: 0;
    left: 0;
    padding-top: 50px;
    position: fixed;
    right: 0;
    top: 0;
    z-index: -1;
}

body::before {
    content: 'Fraud Guard';
    position: fixed;
    top: 20%;
    left: 0;
    width: 100%;
    text-align: center;
    font-size: 6vw;
    font-weight: 900;
    color: rgba(0, 0, 139, 0.1);
    z-index: -1;
    animation: fraudGuardAnimation 10s ease-in-out infinite;
    pointer-events: none;
    text-transform: uppercase;
    letter-spacing: 10px;
}

.navbar {
    background: linear-gradient(90deg, #87CEFA, #4169E1) !important;
    color: white !important;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    border: none;
    transition: all 0.3s ease;
}

.navbar:hover {
    box-shadow: 0 6px 20px rgba(0,0,0,0.15);
}

.tab-content {
    background: linear-gradient(
        135deg, 
        rgba(255,255,255,0.9), 
        rgba(255,255,255,0.7)
    );
    padding: 25px;
    border-radius: 15px;
    box-shadow: 
        0 10px 25px rgba(0,0,0,0.1),
        0 5px 10px rgba(0,0,0,0.05);
    border: 1px solid rgba(135, 206, 250, 0.3);
    backdrop-filter: blur(10px);
    transition: all 0.4s ease;
}

.tab-content:hover {
    box-shadow: 
        0 15px 35px rgba(0,0,0,0.15),
        0 5px 15px rgba(0,0,0,0.1);
    transform: translateY(-5px);
}

.nav-tabs > li.active > a {
    background: linear-gradient(90deg, #87CEFA, #4169E1) !important;
    color: white !important;
    border: none;
    border-radius: 10px;
    transition: all 0.3s ease;
}

.card {
    background: linear-gradient(
        135deg, 
        rgba(255,255,255,0.8), 
        rgba(255,255,255,0.6)
    );
    border: 1px solid rgba(135, 206, 250, 0.2);
    box-shadow: 0 6px 20px rgba(0,0,0,0.1);
    backdrop-filter: blur(8px);
    transition: all 0.4s ease;
}

.card:hover {
    transform: scale(1.02);
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
}

#page-navigation {
    margin-top: 30px;
    text-align: center;
    background: rgba(255,255,255,0.6);
    padding: 15px;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
}

.btn-primary {
    background: linear-gradient(90deg, #87CEFA, #4169E1);
    border: none;
    transition: all 0.3s ease;
    animation: shieldPulse 2s infinite;
}

.btn-primary:hover {
    transform: scale(1.05);
    box-shadow: 0 6px 20px rgba(0,0,0,0.2);
}

.data-table {
    background: linear-gradient(
        135deg, 
        rgba(255,255,255,0.9), 
        rgba(255,255,255,0.7)
    );
    border-radius: 10px;
    overflow: hidden;
}

.data-table thead {
    background: linear-gradient(90deg, #87CEFA, #4169E1);
    color: white;
}

.data-table tr:nth-child(even) {
    background: rgba(135, 206, 250, 0.1);
}

.data-table tr:hover {
    background: rgba(135, 206, 250, 0.2);
    transition: background 0.3s ease;
}

.data-flow {
    background: linear-gradient(
        45deg, 
        #87CEFA, 
        #4169E1, 
        #87CEFA
    );
    background-size: 400% 100%;
    animation: dataFlow 10s linear infinite;
}

.google-sign-in-container {
    display: flex;
    align-items: center;
    position: absolute;
    top: 10px;
    right: 10px;
    z-index: 1000;
}

.user-welcome {
    color: white;
    margin-right: 10px;
    font-weight: 600;
    text-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

.logout-btn {
    background: rgba(255,255,255,0.2);
    color: white;
    border: none;
    padding: 8px 16px;
    border-radius: 20px;
    backdrop-filter: blur(10px);
    transition: all 0.3s ease;
}

.logout-btn:hover {
    background: rgba(255,255,255,0.3);
    transform: scale(1.05);
}"


# UI
ui <- fluidPage(
  tags$head(
    tags$style(HTML(custom_css))
  ),
  theme = shinytheme("cerulean"),
  # Conditional Panel for Authentication
  uiOutput("authentication_ui"),
  # Application Title and Logo
  titlePanel(
    div(
      h2("Fraud Guard", style = "color: #01A3C3;"),
      img(src = "https://static.vecteezy.com/system/resources/previews/032/410/187/large_2x/fraud-thick-line-filled-dark-colors-icons-for-personal-and-commercial-use-free-vector.jpg", height = "50px",class="fraud-logo")
    )
  ),
  # Replace the existing absolutePanel with this
  absolutePanel(
    top = 10, 
    right = 10,
    style = "z-index: 1000;",
    uiOutput("user_display")
  ),
  
  # Navigation Bar
  navbarPage(
    "Fraud Guard",
    id = "main_nav",
    
    # Page 1: Home
    tabPanel("Home", 
             icon = icon("home"),
             div(
               class = "container",
               style = "text-align: center; padding: 20px;",
               h1("Welcome to Fraud Guard!", style = "color: #01A3C3; margin-bottom: 20px;"),
               
               # Application Overview Section
               div(
                 class = "container text-center", 
                 style = "display: flex; justify-content: center; align-items: center; margin-bottom: 30px;",
                 div(
                   class = "col-md-8",
                   p("Fraud Guard: Your Advanced Fraud Detection Platform", 
                     style = "font-size: 22px; color: #2C3E50; font-weight: bold; text-align: center;"),
                   p("Detect, Analyze, and Prevent Fraudulent Activities with Cutting-Edge Machine Learning", 
                     style = "font-size: 18px; color: #34495E; text-align: center;")
                 )
               ),
               
               # Features Section
               div(
                 class = "row",
                 style = "margin-bottom: 30px;",
                 div(
                   class = "col-md-4",
                   div(
                     style = "background-color: rgba(255,255,255,0.7); padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);",
                     icon("upload", class = "fa-3x", style = "color: #3498DB; margin-bottom: 15px;"),
                     h3("Dataset Upload", style = "color: #2980B9;"),
                     p("Easily upload and parse complex datasets with flexible configuration options.")
                   )
                 ),
                 div(
                   class = "col-md-4",
                   div(
                     style = "background-color: rgba(255,255,255,0.7); padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);",
                     icon("chart-line", class = "fa-3x", style = "color: #2ECC71; margin-bottom: 15px;"),
                     h3("Predictive Modeling", style = "color: #27AE60;"),
                     p("Train Random Forest models to predict fraud probabilities with detailed insights.")
                   )
                 ),
                 div(
                   class = "col-md-4",
                   div(
                     style = "background-color: rgba(255,255,255,0.7); padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);",
                     icon("chart-bar", class = "fa-3x", style = "color: #9B59B6; margin-bottom: 15px;"),
                     h3("Data Visualization", style = "color: #8E44AD;"),
                     p("Explore data through interactive 2D and 3D visualization tools.")
                   )
                 )
               ),
               
               # Call to Action
               div(
                 class = "row",
                 style = "margin-top: 30px;",
                 div(
                   class = "col-md-12",
                   actionButton("nav_home_to_upload", "Get Started", 
                                icon = icon("arrow-right"), 
                                class = "btn btn-primary btn-lg"),
                   p("Upload your first dataset and start detecting fraud!", 
                     style = "margin-top: 10px; color: #7F8C8D;")
                 )
               )
             )
    ),
    
  
    # Page 2: Upload Dataset
    tabPanel("Upload Dataset", 
             icon = icon("upload"),
             sidebarLayout(
               sidebarPanel(
                 # New Card for Dataset Requirements
                 div(
                   class = "card",
                   div(
                     class = "card-body",
                     h4("Dataset Upload Requirements", class = "card-title"),
                     tags$ul(
                       tags$li("File must be a CSV format"),
                       tags$li("Include a header row"),
                       tags$li("Last column should be the 'fraud' target variable"),
                       tags$li("Numeric columns preferred for analysis"),
                       tags$li("Recommended columns: transaction amount, time, location, etc.")
                     ),
                     tags$hr(),
                     tags$p("Example dataset structure:", style = "font-weight: bold;"),
                     tags$pre(
                       "transaction_id,amount,time,location,fraud\n",
                       "1,500.00,2023-05-01,New York,0\n",
                       "2,1200.50,2023-05-02,Los Angeles,1\n",
                       "3,75.25,2023-05-03,Chicago,0"
                     )
                   )
                 ),
                 fileInput("file", "Upload CSV File", accept = c(".csv")),
                 checkboxInput("header", "Header", TRUE),
                 selectInput("sep", "Separator", choices = c(Comma = ",", Semicolon = ";", Tab = "\t"), selected = ","),
                 actionButton("loadData", "Load Dataset")
               ),
               mainPanel(
                 DTOutput("dataView"),
                 div(
                   id = "page-navigation",
                   actionButton("nav_upload_to_home", "Previous Page", icon = icon("arrow-left"), class = "btn btn-secondary"),
                   actionButton("nav_upload_to_prediction", "Next Page", icon = icon("arrow-right"), class = "btn btn-primary")
                 )
               )
             )
    ),
    
   
    # Page 3: Prediction
    tabPanel(
      "Prediction",
      icon = icon("chart-line"),
      sidebarLayout(
        sidebarPanel(
          wellPanel(
            h4("Model Training Parameters"),
            numericInput("trainRatio", "Training Data Ratio", 0.7, min = 0, max = 1, step = 0.1),
            actionButton("trainModel", "Train Random Forest Model", class = "btn btn-primary btn-block"),
            hr(),
            h4("Model Performance Metrics")
          ),
          valueBoxOutput("totalTransactions"),
          valueBoxOutput("fraudRate"),
          valueBoxOutput("accuracy")
        ),
        mainPanel(
          tabsetPanel(
            tabPanel("Model Summary", 
                     verbatimTextOutput("modelSummary"),
                     hr(),
                     h4("Prediction Results"),
                     DTOutput("predictedData")
            ),
            tabPanel("Variable Importance", 
                     plotOutput("rfResults"),
                     plotOutput("variableImportancePlot")
            )
          ),
          div(
            id = "page-navigation",
            actionButton("nav_prediction_to_upload", "Previous Page", icon = icon("arrow-left"), class = "btn btn-secondary"),
            actionButton("nav_prediction_to_2d", "Next Page", icon = icon("arrow-right"), class = "btn btn-primary")
          )
        )
      )
    ),
    
    
    # Page 4: 2D Visualization
    tabPanel("2D Visualization", 
             icon = icon("chart-bar"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("xcol2D", "X-Axis", choices = NULL),
                 selectInput("ycol2D", "Y-Axis", choices = NULL),
                 selectInput("plotType2D", "Plot Type", 
                             choices = c("Scatter" = "scatter", 
                                         "Bar" = "bar", 
                                         "Line" = "line")),
                 uiOutput("column_filters_2D")
               ),
               mainPanel(
                 plotlyOutput("plot2D"),
                 div(
                   id = "page-navigation",
                   actionButton("nav_2d_to_prediction", "Previous Page", icon = icon("arrow-left"), class = "btn btn-secondary"),
                   actionButton("nav_2d_to_3d", "Next Page", icon = icon("arrow-right"), class = "btn btn-primary")
                 )
               )
             )
    ),
    
    # Page 5: 3D Visualization
    tabPanel("3D Visualization", 
             icon = icon("cubes"),
             sidebarLayout(
               sidebarPanel(
                 selectInput("xcol3D", "X-Axis", choices = NULL),
                 selectInput("ycol3D", "Y-Axis", choices = NULL),
                 selectInput("zcol3D", "Z-Axis", choices = NULL),
                 selectInput("plotType3D", "Plot Type", 
                             choices = c("3D Scatter" = "scatter3d", 
                                         "3D Line" = "line3d", 
                                         "3D Mesh" = "mesh3d")),
                 uiOutput("column_filters_3D")
               ),
               mainPanel(
                 plotlyOutput("plot3D"),
                 div(
                   id = "page-navigation",
                   actionButton("nav_3d_to_2d", "Previous Page", icon = icon("arrow-left"), class = "btn btn-secondary"),
                   actionButton("nav_3d_to_summary", "Next Page", icon = icon("arrow-right"), class = "btn btn-primary")
                 )
               )
             )
    ),
    
    # Page 6: Dataset Summary
    tabPanel("Dataset Summary", 
             icon = icon("table"),
             verbatimTextOutput("dataSummary"),
             div(
               id = "page-navigation",
               actionButton("nav_summary_to_3d", "Previous Page", icon = icon("arrow-left"), class = "btn btn-secondary")
             )
    )
  )
)

# Server
# Correct server navigation logic and reactive behavior
server <- function(input, output, session) {
  
  # Reactive Variables
  auth_state <- reactiveVal(FALSE)
  user_info <- reactiveVal(NULL)
  dataset <- reactiveVal(NULL)
  # Authentication UI
  output$user_display <- renderUI({
    if (auth_state()) {
      div(
        h4(paste("Logged in as:", user_info()$email), style = "color: #007BFF;"),
        actionButton("logout", "Logout", class = "btn btn-danger")
      )
    } else {
      actionButton("google_login", "Sign in with Google", icon = icon("google"), class = "btn btn-primary")
    }
  })
  # Comprehensive Logout Function
  logout <- function() {
    tryCatch({
      # Revoke Google OAuth token if possible
      # Note: This is a simplified approach and might need adjustment based on your exact OAuth setup
      if (!is.null(getOption("httr_oauth_token"))) {
        revoke_token(getOption("httr_oauth_token"))
      }
      
      # Clear reactive values
      auth_state(FALSE)
      user_info(NULL)
      dataset(NULL)
      
      # Send logout message to client-side
      session$sendCustomMessage("logout", list())
    }, error = function(e) {
      # Log any logout errors
      warning("Logout error: ", e$message)
    })
  }
  # Authentication Check Middleware
  auth_check <- function() {
    if (!auth_state()) {
      showModal(modalDialog(
        title = "Access Denied",
        "Please log in to access this feature.",
        easyClose = TRUE
      ))
      return(FALSE)
    }
    return(TRUE)
  }
  
  # Navigation Event Handlers
  observeEvent(input$nav_home_to_upload, {
    updateTabsetPanel(session, "main_nav", selected = "Upload Dataset")
  })
  observeEvent(input$nav_upload_to_home, {
    updateTabsetPanel(session, "main_nav", selected = "Home")
  })
  observeEvent(input$nav_upload_to_prediction, {
    updateTabsetPanel(session, "main_nav", selected = "Prediction")
  })
  observeEvent(input$nav_prediction_to_upload, {
    updateTabsetPanel(session, "main_nav", selected = "Upload Dataset")
  })
  observeEvent(input$nav_prediction_to_2d, {
    updateTabsetPanel(session, "main_nav", selected = "2D Visualization")
  })
  observeEvent(input$nav_2d_to_prediction, {
    updateTabsetPanel(session, "main_nav", selected = "Prediction")
  })
  observeEvent(input$nav_2d_to_3d, {
    updateTabsetPanel(session, "main_nav", selected = "3D Visualization")
  })
  observeEvent(input$nav_3d_to_2d, {
    updateTabsetPanel(session, "main_nav", selected = "2D Visualization")
  })
  observeEvent(input$nav_3d_to_summary, {
    updateTabsetPanel(session, "main_nav", selected = "Dataset Summary")
  })
  observeEvent(input$nav_summary_to_3d, {
    updateTabsetPanel(session, "main_nav", selected = "3D Visualization")
  })
  # Google Login
  observeEvent(input$google_login, {
    tryCatch({
      oauth_endpoints("google")
      myapp <- oauth_app("google", key = google_client_id, secret = google_client_secret)
      goog_auth <- oauth2.0_token(oauth_endpoints("google"), myapp, scope = scopes, cache = FALSE)
      user_info_res <- GET("https://www.googleapis.com/oauth2/v2/userinfo", config(token = goog_auth))
      user_info_data <- content(user_info_res, as = "parsed", simplifyVector = TRUE)
      
      # Update Authentication State
      auth_state(TRUE)
      user_info(user_info_data)
      
      # Redirect to specified website
      session$sendCustomMessage(type = "redirectAfterLogin", list(url = "https://yourwebsite.com"))
    }, error = function(e) {
      showNotification("Login failed. Please try again.", type = "error")
    })
  })
  
  # Logout Handler
  observeEvent(input$logout, {
    # Perform comprehensive logout
    logout()
    
    # Show logout confirmation
    showModal(modalDialog(
      title = "Logged Out",
      "You have been successfully logged out. Thank you for using Fraud Guard.",
      footer = modalButton("Close"),
      easyClose = TRUE
    ))
    
    # Ensure UI is reset to Home/Login state
    updateTabsetPanel(session, "main_nav", selected = "Home")
  })
  
  
  # Load Dataset - Now with authentication check
  observeEvent(input$loadData, {
    # Ensure user is authenticated
    if (!auth_check()) return()
    
    req(input$file)
    tryCatch({
      data <- read.csv(input$file$datapath, header = input$header, sep = input$sep)
      dataset(data)
    }, error = function(e) {
      showModal(modalDialog(
        title = "Error",
        "Failed to load dataset. Please check the file format.",
        easyClose = TRUE
      ))
    })
  })
  
  # Display Dataset
  output$dataView <- renderDT({
    # Ensure dataset and authentication
    req(dataset())
    if (!auth_check()) return(NULL)
    datatable(dataset())
  })
  
  # Train Random Forest Model
  observeEvent(input$trainModel, {
    # Require that a dataset is available
    req(dataset())
    
    # Get the dataset
    data <- dataset()
    
    # Assume the last column is the target variable
    target_col <- names(data)[ncol(data)]
    
    tryCatch({
      # Step 1: Split data into training and testing sets
      trainIndex <- sample(seq_len(nrow(data)), 
                           size = input$trainRatio * nrow(data))
      train <- data[trainIndex, ]
      test <- data[-trainIndex, ]
      
      # Step 2: Train Random Forest model
      rfModel <- randomForest(
        x = train[, -ncol(train), drop = FALSE],  # All columns except target
        y = train[[target_col]],                  # Target column
        ntree = 500,                              # Number of trees
        importance = TRUE                         # Calculate variable importance
      )
      
      # Step 3: Make predictions and calculate accuracy
      predictions <- predict(rfModel, test[, -ncol(test), drop = FALSE])
      accuracy <- round(mean(predictions == test[[target_col]]) * 100, 2)  # Accuracy in percentage
      
      # Step 4: Extract variable importance
      variable_importance <- as.data.frame(importance(rfModel, type = 1))  # Type 1: Mean Decrease Accuracy
      variable_importance$Variable <- rownames(variable_importance)
      
      # Render Model Summary
      output$modelSummary <- renderPrint({
        req(dataset())
        df <- dataset()
        print(rfModel)
        rf_model <- randomForest(as.factor(fraud) ~ ., data = df, ntree = 100)
        accuracy <- mean(rf_model$predicted == df$fraud) * 100
        cat("\nModel Accuracy:", accuracy, "%\n")
        cat("\nVariable Importance (Mean Decrease Accuracy):\n")
        print(variable_importance)
      })
      
      # Render Predictions Table
      output$predictedData <- renderDT({
        datatable(
          data.frame(test, Predicted = predictions),
          options = list(scrollX = TRUE)
        )
      })
      
      
      
      # Render Random Forest Variable Importance Plot
      output$rfResults <- renderPlot({
        varImpPlot(rfModel)
      })
      
      # Step 5: Calculate and Render Value Boxes
      # Total Transactions
      output$totalTransactions <- renderValueBox({
        valueBox(
          nrow(dataset()),
          "Total Transactions",
          icon = icon("list"),
          color = "blue"
        )
      })
      
      # Fraud Rate
      output$fraudRate <- renderValueBox({
        tryCatch({
          fraud_rate <- mean(dataset()$fraud, na.rm = TRUE) * 100
          valueBox(
            paste0(round(fraud_rate, 2), "%"),
            "Fraud Rate",
            icon = icon("warning"),
            color = "red"
          )
        }, error = function(e) {
          valueBox("N/A", "Fraud Rate", icon = icon("warning"), color = "red")
        })
      })
      
      # Model Accuracy
      output$accuracy <- renderValueBox({
        req(dataset())
        tryCatch({
          df <- dataset()
          rf_model <- randomForest(as.factor(fraud) ~ ., data = df, ntree = 100)
          accuracy <- mean(rf_model$predicted == df$fraud) * 100
          valueBox(
            paste0(round(accuracy, 2), "%"),
            "Model Accuracy",
            icon = icon("check"),
            color = "green"
          )
        }, error = function(e) {
          valueBox("N/A", "Model Accuracy", icon = icon("check"), color = "green")
        })
      })
      
    }, error = function(e) {
      # Handle errors gracefully with a modal dialog
      showModal(modalDialog(
        title = "Error",
        paste("Model training failed:", e$message),
        easyClose = TRUE
      ))
    })
  })
  



  
  # Dynamic 2D Column Filters
  output$column_filters_2D <- renderUI({
    req(dataset())
    data <- dataset()
    numeric_cols <- names(data)[sapply(data, is.numeric)]
    if (length(numeric_cols) == 0) return(NULL)
    lapply(numeric_cols, function(col) {
      sliderInput(
        inputId = paste0("filter_2D_", col),
        label = paste("Filter", col),
        min = min(data[[col]], na.rm = TRUE),
        max = max(data[[col]], na.rm = TRUE),
        value = c(min(data[[col]], na.rm = TRUE), max(data[[col]], na.rm = TRUE))
      )
    })
  })
  
  # Dynamic 3D Column Filters
  output$column_filters_3D <- renderUI({
    req(dataset())
    data <- dataset()
    numeric_cols <- names(data)[sapply(data, is.numeric)]
    if (length(numeric_cols) == 0) return(NULL)
    lapply(numeric_cols, function(col) {
      sliderInput(
        inputId = paste0("filter_3D_", col),
        label = paste("Filter", col),
        min = min(data[[col]], na.rm = TRUE),
        max = max(data[[col]], na.rm = TRUE),
        value = c(min(data[[col]], na.rm = TRUE), max(data[[col]], na.rm = TRUE))
      )
    })
  })
  
  # 2D Visualization
  observe({
    req(dataset())
    cols <- colnames(dataset())
    updateSelectInput(session, "xcol2D", choices = cols)
    updateSelectInput(session, "ycol2D", choices = cols)
  })
  output$plot2D <- renderPlotly({
    req(input$xcol2D, input$ycol2D, dataset())
    data <- dataset()
    for (col in names(data)[sapply(data, is.numeric)]) {
      filter_range <- input[[paste0("filter_2D_", col)]]
      if (!is.null(filter_range)) {
        data <- data[data[[col]] >= filter_range[1] & data[[col]] <= filter_range[2], ]
      }
    }
    plot_ly(data, x = ~get(input$xcol2D), y = ~get(input$ycol2D), type = input$plotType2D)
  })
  
  # 3D Visualization
  observe({
    req(dataset())
    cols <- colnames(dataset())
    updateSelectInput(session, "xcol3D", choices = cols)
    updateSelectInput(session, "ycol3D", choices = cols)
    updateSelectInput(session, "zcol3D", choices = cols)
  })
  output$plot3D <- renderPlotly({
    req(input$xcol3D, input$ycol3D, input$zcol3D, dataset())
    data <- dataset()
    for (col in names(data)[sapply(data, is.numeric)]) {
      filter_range <- input[[paste0("filter_3D_", col)]]
      if (!is.null(filter_range)) {
        data <- data[data[[col]] >= filter_range[1] & data[[col]] <= filter_range[2], ]
      }
    }
    plot_ly(data, x = ~get(input$xcol3D), y = ~get(input$ycol3D), z = ~get(input$zcol3D), type = input$plotType3D)
  })
  
  # Dataset Summary
  output$dataSummary <- renderPrint({
    req(dataset())
    summary(dataset())
  })
  
  # Reactive for user display
  output$user_display <- renderUI({
    if (auth_state()) {
      # Shifted "Logout" button position below the welcome message
      div(
        style = "display: flex; flex-direction: column; align-items: flex-end; gap: 5px;",
        h4(paste("Welcome", user_info()$name, "👋"), style = "margin: 0; color: #007BFF;"),
        actionButton("logout", "Logout", class = "btn btn-danger btn-sm")
      )
    } else {
      # Adjusted "Login" button position
      div(
        style = "display: flex; justify-content: flex-end;",
        actionButton("google_login", "Sign in with Google", icon = icon("google"), class = "btn btn-primary")
      )
    }
  })
  
}


# Run the Application
shinyApp(ui = ui, server = server)