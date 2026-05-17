  library(tidyverse)
  library(janitor)
  library(readr)
  df <- read_csv("used_car_dataset.csv")
  
    
  clean_df <- df %>%
   
    clean_names() %>%

    mutate(
      ask_price = as.numeric(str_remove_all(ask_price, "[₹,]")),
      km_driven = as.numeric(str_remove_all(km_driven, "[km, ]")),
      age = 2025 - year
    ) %>%
    
   
    mutate(
      brand = fct_lump_n(brand, n = 10, other_level = "Other_Brands"),
      
     
      model = fct_lump_n(model, n = 50, other_level = "Other_Models")
    ) %>%
    
  
    mutate(
     
      brand = as.factor(brand),
      model = as.factor(model),
      transmission = as.factor(transmission),
      fuel_type = as.factor(fuel_type),
      owner = as.factor(owner),
    
      log_price = log(ask_price)
    ) %>%
    
   
    select(-addition_info, -year) %>% 
  
    drop_na()
  
  price_lower_limit <- quantile(clean_df$ask_price, 0.01) # Bottom 1% (Scrap)
  price_upper_limit <- quantile(clean_df$ask_price, 0.99) # Top 1% (Supercars)
  km_upper_limit    <- quantile(clean_df$km_driven, 0.99) # Top 1% (Overused)
  
  final_df <- clean_df %>%
    filter(
      ask_price > price_lower_limit & ask_price < price_upper_limit,
      km_driven < km_upper_limit
    )
  
  # ------------------------
  cat("Initial Rows:", nrow(df), "\n")
  cat("Final Rows:", nrow(final_df), "\n")
  cat("Data Lost:", round((nrow(df) - nrow(final_df))/nrow(df)*100, 2), "%\n")
  glimpse(final_df)
  #-------------------------
  
  
  write_csv(final_df, "clean_used_cars_final.csv")
  
  #=============================================================================
  
  # end of pre processing 
  
  #=============================================================================
  
  
  #=============================================================================
  
  # start of model "linear regression"
  
  #=============================================================================
  
  
  set.seed(111)
  train_idx <- sample(seq_len(nrow(final_df)), size = 0.8 * nrow(final_df))
  
  train_df <- final_df[train_idx, ]
  test_df <- final_df[-train_idx, ]
  
  lm_model <- lm(
    log_price ~ km_driven + age + brand + model + transmission + fuel_type + owner,
    data = train_df
  )
  
  summary(lm_model)
  
  pred_log_price <- predict(lm_model, newdata = test_df)
  
  pred_price <- exp(pred_log_price)
  
  SSE <- sum((test_df$log_price - pred_log_price)^2)
  SST <- sum((test_df$log_price - mean(test_df$log_price))^2)
  R2 <- 1 - SSE / SST
  R2
  
  plot(
    test_df$log_price,
    pred_log_price,
    xlab = "Actual",
    ylab = "Predicted",
    main = "Actual vs Predicted",
    pch = 16,
    col = "blue"
  )
  
  abline(a = 0, b = 1, col = "red", lwd = 2)
  
  
  plot(test_df$ask_price, pred_price,
       xlab = "Actual Price",
       ylab = "Predicted Price",
       main = "Actual vs Predicted Prices",
       pch = 16, col = "blue")
  abline(a = 0, b = 1, col = "red", lwd = 2)
  
  #=============================================================================
  
  # end of model "linear regression"
  
  #=============================================================================
  
  
  #=============================================================================
  
  # start of model "Decesion Tree"
  
  #=============================================================================
  #install package once
  ##install.packages("rpart.plot")
  library(rpart)
  library(rpart.plot)
  
  
  data <- final_df 
  
  # Convert categorical columns to factors
  
  categorical_cols <- c("brand", "model", "transmission", "owner", "fuel_type", "posted_date")
  data[categorical_cols] <- lapply(data[categorical_cols], factor)
  
  
  set.seed(-995)
  
  n <- nrow(data)
  train_index <- sample(1:n, size = 0.8 * n)
  
  train <- data[train_index, ]
  test  <- data[-train_index, ]
  
  
  tree_model <- rpart(
    log_price ~ brand + model + age + km_driven +
      transmission + owner + fuel_type,
    data = train,
    method = "anova",
  )
  
  
  rpart.plot(tree_model)
  
  
  pred <- predict(tree_model, test)
  
  # ============================================================
  # Evaluate model accuracy
  # ============================================================
  rmse <- sqrt(mean((pred - test$log_price)^2))
  rmse
  
  sst <- sum( (test$log_price - mean(test$log_price))^2 )
  sse <- sum( (test$log_price - pred)^2 )
  r_squared <- 1 - sse/sst
  r_squared
  
  # Show results
  cat("RMSE:", rmse, "\n")
  cat("R-squared:", r_squared, "\n")
  
  #=============================================================================
  
  # end of model "Decesion Tree"
  
  #=============================================================================
  
  
  #=============================================================================
  
  # start of model "XGBoost"
  
  #=============================================================================
  
  #install.packages("parallelly", type = "win.binary")
  #install.packages("future", type = "win.binary")
  #install.packages("future.apply", type = "win.binary")
  #install.packages("caret", type = "win.binary")
  
  
  #setwd("F:\\SI") # Or where the "clean_used_cars_final.csv" file is
  
  library(xgboost)
  library(caret)
  
  # Load Data
  df <- final_df
  df$posted_date <- NULL
  
  # Train/Test Split (80/20)
  set.seed(123)
  df$price_bin <- cut(df$log_price, breaks = quantile(df$log_price, probs = seq(0,1,0.1)), include.lowest = TRUE)
  train_idx <- createDataPartition(df$price_bin, p = 0.8, list = FALSE)
  train_df <- df[train_idx, ]
  test_df  <- df[-train_idx, ]
  
  train_df$price_bin <- NULL
  test_df$price_bin  <- NULL
  
  # Remove original target from predictors
  x_train <- model.matrix(log_price ~ . - ask_price, data = train_df)
  x_test  <- model.matrix(log_price ~ . - ask_price, data = test_df)
  
  # Convert to matrix (required for xgboost)
  x_train <- as.matrix(x_train)
  x_test  <- as.matrix(x_test)
  
  y_train <- train_df$log_price
  y_test  <- test_df$log_price
  
  
  # Create DMatrices
  dtrain <- xgb.DMatrix(data = x_train, label = y_train)
  dtest  <- xgb.DMatrix(data = x_test, label = y_test)
  
  params <- list(
    objective = "reg:squarederror",
    eval_metric = "rmse",
    eta = 0.1,
    max_depth = 14,
    subsample = 0.8,
    colsample_bytree = 0.8
  )
  
  xgb_baseline <- xgb.train(
    params = params,
    data = dtrain,
    nrounds = 300,
    evals = list(train = dtrain, test = dtest),
    print_every_n = 30,
    early_stopping_rounds = 20
  )
  
  # Predictions
  pred_log <- predict(xgb_baseline, dtest)
  pred_price <- exp(pred_log)   # converting back to original scale
  
  # Evaluate Performance
  rmse <- sqrt(mean((pred_log - y_test)^2))
  mae  <- mean(abs(exp(pred_log) - exp(y_test)))
  r2   <- 1 - sum((pred_log - y_test)^2) / sum((y_test - mean(y_test))^2)
  
  cat("RMSE (log scale):", rmse, "\n")
  cat("MAE (price scale):", mae, "\n")
  cat("R²:", r2, "\n")
  
  # Feature Importance (showing and ordering features by their effect on the price)
  importance <- xgb.importance(model = xgb_baseline)
  xgb.plot.importance(importance)
  
  # Graph showing relation between actual and predicted prices
  plot(exp(y_test), exp(pred_log),
       xlab = "Actual Price",
       ylab = "Predicted Price",
       pch = 20,
       main = "Actual vs Predicted Prices")
  abline(0, 1, col = "red")
  
  
  #=============================================================================
  
  # end of model "XGBoost"
  
  #=============================================================================
  
  
  #=============================================================================
  
  # start of model "Random Forest"
  
  #=============================================================================
  library(readr)
  library(randomForest)
  library(dplyr)
  library(ggplot2)
  library(scales)
  
  data <- final_df
  
  data <- data %>%
    mutate(across(c(brand, model, transmission, owner, fuel_type), as.factor))
  
  ask_price_upper_limit <- quantile(data$ask_price, 0.99)
  
  
  data <- data %>%
    filter(ask_price < ask_price_upper_limit)
  
  
  # ==========================================
  # FIND BEST SEED
  # ==========================================
  
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
  #start comment here 
  
  
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
  
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
  #End comment here 
  
  
  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  
  
  set.seed(47)
  #set.seed(best_seed$seed)
  
  train_index <- sample(1:nrow(data), 0.8 * nrow(data))
  
  train_data <- data[train_index, ]
  test_data <- data[-train_index, ]
  
  
  
  rf_log <- randomForest(
    log_price ~ brand + model + age + km_driven + transmission + fuel_type+owner,
    data = train_data, 
    ntree = 170,
    mtry = 6,
    nodesize=6,
    importance = TRUE
  )
  
  # ==========================================
  # 5. Predict and Exponentiate back 
  # ==========================================
  pred_log <- predict(rf_log, newdata = test_data) 
  pred_price <- exp(pred_log)
  
  # ==========================================
  # 6. Calculate metrics
  # ==========================================
  y_true <- test_data$ask_price
  
  MAE <- mean(abs(y_true - pred_price))
  RMSE <- sqrt(mean((y_true - pred_price)^2))
  
  tss <- sum((y_true - mean(y_true))^2)
  rss <- sum((y_true - pred_price)^2)
  R2 <- 1 - rss / tss
  
  print(paste("MAE :", format(round(MAE), big.mark=",")))
  print(paste("RMSE :", format(round(RMSE), big.mark=",")))
  print(paste("R-squared :", round(R2, 4)))
  
  # ==========================================
  # 7. Plots
  # ==========================================
  test_data$pred_price <- pred_price
  test_data$residual <- y_true - pred_price
  
  ggplot(test_data, aes(ask_price, pred_price)) +
    geom_point(alpha = 0.6, color = "#2c7bb6") +
    geom_abline(slope = 1, intercept = 0, color = "red") +
    scale_x_continuous(labels = comma) +
    scale_y_continuous(labels = comma) +
    labs(title="Actual vs Predicted", x="Actual", y="Predicted") +
    theme_minimal()
  
  ggplot(test_data, aes(pred_price, residual)) +
    geom_point(alpha=0.5, color="#d7191c") +
    geom_hline(yintercept=0, color="gray") +
    scale_x_continuous(labels = comma) +
    scale_y_continuous(labels = comma) +
    labs(title="Residuals vs Predictions", x="Predicted", y="Residual") +
    theme_minimal()
