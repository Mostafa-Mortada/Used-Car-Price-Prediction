# Used Car Price Prediction Using Regression and Ensemble Models

<p align="center">

  <img src="https://img.shields.io/badge/Language-R-276DC3?style=for-the-badge&logo=r&logoColor=white"/>
  <img src="https://img.shields.io/badge/Machine%20Learning-Regression%20%26%20Ensemble-blue?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Models-Linear%20%7C%20Decision%20Tree%20%7C%20XGBoost%20%7C%20Random%20Forest-orange?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Status-Research%20Project-success?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/IEEE-Paper%20Format-lightgrey?style=for-the-badge&logo=ieee"/>

</p>

---

## 📌 Abstract

Accurate price estimation in the used car market is challenging due to complex and nonlinear interactions between vehicle attributes. This project evaluates statistical and machine learning models for predicting used car prices in the Indian second-hand car market. Using a real-world dataset of 9,582 car listings (cleaned to 9,238 records), we compare Linear Regression, Decision Tree Regression, XGBoost, and Random Forest under a unified preprocessing and evaluation framework.

The results show that ensemble-based methods significantly outperform traditional models. XGBoost and Random Forest achieved the highest predictive performance, with R² values around 0.85, demonstrating strong generalization and the ability to capture nonlinear feature interactions.

---

## 📄 Paper

📘 Full IEEE Paper:  
[Download PDF](./final.pdf)

---
## 🎯 Objectives

- Analyze the impact of vehicle attributes on used car prices  
- Compare traditional regression models with tree-based and ensemble methods  
- Evaluate models using consistent preprocessing and evaluation metrics  
- Identify the most effective approach for real-world price prediction  

---

## 🧠 Models Evaluated

- Linear Regression (Baseline)
- Decision Tree Regression
- XGBoost Regression
- Random Forest Regression

All models were trained using the same feature set and evaluated using an 80–20 train-test split.

---

## 🏗 System Architecture

1. **Data Preprocessing**
   - Data cleaning and formatting  
   - Handling missing values  
   - Encoding categorical variables  
   - Log transformation of target variable  
   - Outlier detection and removal  

2. **Feature Engineering**
   - Vehicle age calculation  
   - High-cardinality feature grouping  
   - Feature selection and transformation  

3. **Model Development**
   - Training regression and ensemble models  

4. **Evaluation**
   - Metrics: MAE, RMSE, R²  
   - Comparative performance analysis  

---

## 📊 Dataset Description

- Source: Online used car listings (India)  
- Initial records: 9,582  
- Final cleaned dataset: 9,238  
- Features: 11 vehicle-related attributes  

---

## ⚙️ Preprocessing Steps

### Data Cleaning
- Removed currency symbols, commas, and text artifacts  
- Converted numeric columns to proper data types  
- Computed vehicle age:
  - Age = 2025 − Year  

### Feature Handling
- Brand: Top 10 categories retained  
- Model: Top 50 categories retained  

### Transformation
- Log transformation applied to target (Price)  
- Categorical encoding for ML compatibility  

### Outlier Removal
- Removed extreme price values (1st–99th percentile)  
- Filtered vehicles with excessive mileage (>220,000 km)  

---

## 📈 Results

| Model              | R²     | RMSE     | MAE       |
|--------------------|--------|----------|-----------|
| Linear Regression  | ~0.78  | —        | —         |
| Decision Tree      | ~0.73  | —        | —         |
| XGBoost            | ~0.85  | ~0.33    | ~222,000  |
| Random Forest      | **0.8555** | **322,288** | **163,751** |

### 🔍 Key Findings
- Ensemble models outperform traditional regression methods  
- Vehicle age, mileage, and brand are dominant predictors  
- Random Forest provides the most stable performance  

---

## 💡 Discussion

Linear Regression captures general trends but struggles with nonlinear relationships. Decision Trees improve flexibility but are prone to overfitting. XGBoost and Random Forest provide strong generalization and robustness, making them more suitable for real-world pricing systems.

---

## 🏁 Conclusion

This study demonstrates that ensemble learning methods, particularly Random Forest and XGBoost, significantly outperform traditional regression techniques for used car price prediction. With R² values exceeding 0.85, these models effectively capture complex feature interactions and deliver strong predictive accuracy.

The project provides a reproducible pipeline and serves as a benchmark for future research in automotive price estimation.

---

## 👨‍💻 Authors

- Moustafa Mortada Mohamed  
- Mohammed Ahmed Mohammed Abdelghani  
- Ammar Mohammed Ali Ali  
- Omar Karam Sayed Ramadan  
- Salma Khaled Mahmoud Al-Bahai  
- Peter Emad Adly Shafiq  

Faculty of Computer and Information Sciences  
Ain Shams University – Cairo, Egypt  

---

## ⭐ Future Work

- Hyperparameter tuning for ensemble models  
- Integration of deep learning models  
- Deployment as a web-based price prediction system  
- Feature expansion with market and economic indicators  

---
