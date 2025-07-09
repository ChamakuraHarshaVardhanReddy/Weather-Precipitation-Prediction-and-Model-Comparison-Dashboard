# ☁️ Weather Precipitation Prediction using R & Shiny

This project builds a predictive analytics dashboard to classify precipitation types (Sunny, Rain, Snow) using machine learning models trained on historical weather data. The models are evaluated based on accuracy and confusion matrices, visualized using **R**, **ggplot2**, and **Shiny**.

---

## 📦 Project Overview

- **Language**: R  
- **Framework**: Shiny  
- **Visualization**: ggplot2  
- **Dataset**: Historical weather data with temperature, humidity, wind speed, and precipitation type

---

## 🎯 Objectives

- Clean and preprocess raw weather data  
- Train and compare 4 classification models:
  - K-Nearest Neighbors (KNN)
  - Naive Bayes
  - Decision Tree
  - Support Vector Machine (SVM)
- Visualize:
  - Accuracy comparison across models
  - Confusion matrix for each model
- Deploy a user-friendly **Shiny dashboard** for interactive exploration

---

## 🧹 Data Cleaning & Preprocessing

- Removed null and duplicated records
- Replaced `"null"` precipitation types with `"Sunny"`
- Normalized continuous variables using `scale()`
- Converted `Precip.Type` into a factor (target variable)

---

## 🧠 Machine Learning Models

| Model            | Technique                      |
|------------------|--------------------------------|
| **KNN**          | Distance-based classification (k=3) |
| **Naive Bayes**  | Probabilistic model using Bayes theorem |
| **Decision Tree**| Rule-based flowchart model      |
| **SVM**          | Linear support vector classification |

---

## ✅ Accuracy Results

Each model was trained and evaluated using an 80-20 data split. Below are the actual model accuracy scores:

| Model                  | Accuracy (%) |
|------------------------|--------------|
| **Support Vector Machine (SVM)** | **89.7%** ✅ *(Best)*  
| Decision Tree          | 88.2%  
| Naive Bayes            | 85.6%  
| K-Nearest Neighbors (KNN) | 84.3%  

> SVM was the top performer, followed closely by Decision Tree and Naive Bayes.

---

## 📊 Visual Outputs

### 1. Accuracy Comparison
- Bar chart comparing the performance of each algorithm using `ggplot2`.

### 2. Confusion Matrices
- Visualized for each model using tile plots:
  - KNN
  - Naive Bayes
  - Decision Tree
  - SVM

---

## 💻 Shiny Dashboard

The dashboard provides an intuitive interface with:

- **Sidebar**:
  - Descriptions of each ML model used
  - Purpose and features of the dashboard

- **Main Panel Tabs**:
  - `Accuracy Comparison`: Bar plot of all model accuracies  
  - `KNN Confusion Matrix`  
  - `Naive Bayes Confusion Matrix`  
  - `Decision Tree Confusion Matrix`  
  - `SVM Confusion Matrix`


