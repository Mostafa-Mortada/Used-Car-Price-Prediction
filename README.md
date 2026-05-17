#  Used Car Price Prediction Using Regression and Ensemble Models

## An Empirical Evaluation of Regression and Tree-Based Models for Used Car Price Estimation

**Authors**
- Moustafa Mortada Mohamed  
- Mohammed Ahmed Mohammed Abdelghani  
- Ammar Mohammed Ali Ali  
- Omar Karam Sayed Ramadan  
- Salma Khaled Mahmoud Al-Bahai  
- Peter Emad Adly Shafiq  

Faculty of Computer and Information Sciences  
Ain Shams University – Cairo, Egypt  

 **Full Paper:** [Download PDF](./final.pdf)

---

##  Abstract

Accurate price estimation in the used car market is challenging due to complex and nonlinear interactions between vehicle attributes. This project evaluates statistical and machine learning models for predicting used car prices in the Indian second-hand car market. Using a real-world dataset of 9,582 car listings (cleaned to 9,238 records), we compare **Linear Regression**, **Decision Tree Regression**, **XGBoost**, and **Random Forest** under a unified preprocessing and evaluation framework.

The results show that ensemble-based methods significantly outperform traditional models. **XGBoost** and **Random Forest** achieved the highest predictive performance, with R² values around **0.85**, demonstrating strong generalization and the ability to capture nonlinear feature interactions.

---

##  Objectives

- Analyze the impact of vehicle attributes on used car prices  
- Compare traditional regression models with tree-based and ensemble methods  
- Evaluate models using consistent preprocessing and evaluation metrics  
- Identify the most effective approach for real-world price prediction  

---

##  Models Evaluated

- Linear Regression (Baseline)
- Decision Tree Regression
- XGBoost Regression
- Random Forest Regression

All models were trained and evaluated using the same feature set and an **80–20 train–test split**.

---

##  System Architecture

1. **Data Preprocessing**
   - Data cleaning and formatting
   - Categorical encoding
   - Logarithmic transformation of target variable
   - Outlier treatment

2. **Model Development**
   - Training regression and ensemble models

3. **Model Training & Evaluation**
   - Metrics: R², RMSE, MAE

4. **Performance Analysis**
   - Comparative evaluation and stability analysis

---

##  Methodology

### Dataset
- Source: Online used car listings (India)
- Initial rows: 9,582
- Final rows after preprocessing: 9,238
- Attributes: 11 vehicle features

### Preprocessing Steps

**Data Cleaning**
- Removed currency symbols, commas, and units
- Converted numerical fields to numeric types
- Recalculated vehicle age using:
  Age = 2025 − Year

**Handling High-Cardinality Features**
- Brand: Top 10 brands retained
- Model: Top 50 models retained

**Encoding & Transformation**
- Categorical variables encoded as factors
- Target variable log-transformed

**Outlier Treatment**
- Removed extreme price values (1st–99th percentile)
- Removed vehicles with mileage > 220,000 km

---

##  Results

| Model            | R²     | RMSE     | MAE      |
|------------------|--------|----------|----------|
| Linear Regression | ~0.78 | —        | —        |
| Decision Tree     | ~0.73 | —        | —        |
| XGBoost           | ~0.85 | ~0.33    | ~222,000 |
| Random Forest     | **0.8555** | **322,288** | **163,751** |

**Key Findings**
- Ensemble models significantly outperform traditional approaches
- Vehicle age, kilometers driven, and brand are dominant predictors
- Random Forest shows high stability across multiple random seeds

---

##  Discussion

Linear Regression captures general pricing trends but struggles with nonlinear relationships. Decision Trees improve flexibility but are sensitive to data splits. XGBoost and Random Forest provide superior accuracy and robustness, making them more suitable for real-world pricing tasks.

---

##  Conclusion

Ensemble learning methods, particularly **Random Forest** and **XGBoost**, significantly outperform traditional regression techniques for used car price prediction. With R² values exceeding **0.85**, these models effectively capture complex feature interactions and generalize well to unseen data.

This project provides a comprehensive comparison of predictive models on a real-world dataset and serves as a strong benchmark for future research and applications in automotive price prediction.

--- 
