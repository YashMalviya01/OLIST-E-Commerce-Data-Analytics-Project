# 🛒 Olist E-Commerce Analytics Platform

<p align="center">
  <img src="screenshots/project_banner.png" width="100%">
</p>

<p align="center">

![Snowflake](https://img.shields.io/badge/Snowflake-Data%20Warehouse-blue)
![AWS](https://img.shields.io/badge/AWS-S3-orange)
![Python](https://img.shields.io/badge/Python-Analytics-yellow)
![SQL](https://img.shields.io/badge/SQL-Analysis-green)
![Tableau](https://img.shields.io/badge/Tableau-Visualization-red)

</p>

---

# 📌 Project Overview

The **Olist E-Commerce Analytics Platform** is a complete end-to-end Business Intelligence and Data Analytics project built using **AWS S3, Snowflake, SQL, Python, and Tableau**.

The project transforms raw e-commerce transaction data into actionable business insights through a modern analytics workflow involving:

* Data Ingestion
* Data Warehousing
* Data Cleaning
* Data Profiling
* Feature Engineering
* Data Modeling
* Business Analysis
* Dashboard Development
* Data Storytelling

This project simulates a real-world analytics environment used by modern Data Analysts, Analytics Engineers, and Business Intelligence teams.

---

# 🎯 Business Objectives

The goal of this project is to answer critical business questions such as:

* Which states generate the highest revenue?
* Which cities contribute most to sales?
* Which product categories drive revenue?
* What payment methods are preferred by customers?
* How do delivery delays affect customer satisfaction?
* Which sellers contribute most to revenue?
* Who are the highest-value customers?
* What drives customer retention and loyalty?

---

# 🏗️ Solution Architecture

```text
                    ┌─────────────────┐
                    │    Amazon S3    │
                    │   Raw Datasets  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │   Snowflake     │
                    │ Staging Layer   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Data Cleaning   │
                    │ Transformation  │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Data Mart Layer │
                    │ Star Schema     │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Business Layer  │
                    │ SQL Analytics   │
                    └────────┬────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │    Tableau      │
                    │ Dashboards      │
                    └─────────────────┘
```

---

# 🛠️ Technology Stack

| Category             | Technology    |
| -------------------- | ------------- |
| Cloud Storage        | AWS S3   
| Data Validation      | AWS Athena    |
| Data Automation      | AWS Glue
| Data Warehouse       | Snowflake     |
| Programming Language | Python        |
| Query Language       | SQL           |
| Visualization        | Tableau       |
| Version Control      | GitHub        |

---

# 📂 Repository Structure

```text
Olist-Ecommerce-Analytics/
│
├── data/
│   ├── raw/
│   ├── cleaned/
│   └── business_outputs/
│
├── sql/
│   ├── 01_staging.sql
│   ├── 02_data_profiling.sql
│   ├── 03_data_cleaning.sql
│   ├── 04_data_modeling.sql
│   ├── 05_feature_engineering.sql
│   └── 06_business_analysis.sql
│
├── tableau/
│   ├── Dashboard_1.twbx
│   ├── Dashboard_2.twbx
│   ├── Dashboard_3.twbx
│   
│
├── screenshots/
│
├── docs/
│
└── README.md
```

---

# 🗄️ Data Warehouse Design

## Staging Tables

Raw datasets loaded from Amazon S3:

* Customers
* Orders
* Order Items
* Payments
* Reviews
* Products
* Sellers
* Geolocation

---

# ⭐ Star Schema

```text
                      DIM_CUSTOMERS
                              │
                              │
DIM_PRODUCTS ───── FACT_ORDERS ───── DIM_SELLERS
                              │
                              │
                         DIM_DATE

FACT_PAYMENTS
FACT_REVIEWS
```

---

# 🔍 Data Profiling

Performed extensive SQL profiling on all datasets.

### Customer Analysis

| Metric           | Result    |
| ---------------- | --------- |
| Total Customers  | 99,441    |
| Unique Customers | 96,096    |
| Top State        | São Paulo |
| Top City         | São Paulo |

---

### Product Analysis

| Metric                      | Result |
| --------------------------- | ------ |
| Missing Categories          | 610    |
| Missing Description Length  | 610    |
| Missing Product Name Length | 610    |

---

### Payment Analysis

| Payment Method | Orders |
| -------------- | ------ |
| Credit Card    | 76,795 |
| Boleto         | 19,784 |
| Voucher        | 5,775  |
| Debit Card     | 1,529  |

---

### Review Analysis

| Review Score | Reviews |
| ------------ | ------- |
| 5            | 57,328  |
| 4            | 19,142  |
| 3            | 8,179   |
| 2            | 3,151   |
| 1            | 11,424  |

---

# 🧹 Data Cleaning

The following cleaning operations were performed:

✅ Null Value Handling

✅ Duplicate Detection

✅ Data Type Conversion

✅ Date Standardization

✅ Category Normalization

✅ Missing Product Attribute Handling

✅ Review Integrity Validation

---

# ⚙️ Feature Engineering

Several analytical metrics were generated.

### Delivery Days

```sql
SELECT
    ORDER_ID,
    DATEDIFF(
        DAY,
        ORDER_PURCHASE_TIMESTAMP,
        ORDER_DELIVERED_CUSTOMER_DATE
    ) AS DELIVERY_DAYS
FROM FACT_ORDERS;
```

---

### Average Order Value (AOV)

```sql
SELECT
    ROUND(
        SUM(REVENUE) /
        COUNT(DISTINCT ORDER_ID),
        2
    ) AS AOV
FROM FACT_ORDERS;
```

---

### Customer Lifetime Value

```sql
SELECT
    CUSTOMER_UNIQUE_ID,
    COUNT(DISTINCT ORDER_ID) AS TOTAL_ORDERS,
    SUM(REVENUE) AS CUSTOMER_LIFETIME_VALUE
FROM FACT_ORDERS
GROUP BY CUSTOMER_UNIQUE_ID;
```

---

# 📊 Business Questions Solved

| #  | Business Question                             |
| -- | --------------------------------------------- |
| 1  | What is total revenue?                        |
| 2  | What is total order volume?                   |
| 3  | Which states generate the highest revenue?    |
| 4  | Which cities generate the highest revenue?    |
| 5  | What is the monthly revenue trend?            |
| 6  | Which categories generate the most revenue?   |
| 7  | Which categories sell the most units?         |
| 8  | Which payment methods are preferred?          |
| 9  | What is customer satisfaction distribution?   |
| 10 | How do delivery delays impact reviews?        |
| 11 | Which sellers generate the most revenue?      |
| 12 | Which states contain the top sellers?         |
| 13 | What are installment payment trends?          |
| 14 | What is average order value?                  |
| 15 | What is average delivery time?                |
| 16 | What are freight cost patterns?               |
| 17 | Who are the highest-value customers?          |
| 18 | What is repeat customer behavior?             |
| 19 | What is customer lifetime value distribution? |
| 20 | What are the key business drivers?            |

---

# 📈 KPI Dictionary

| KPI               | Formula                       |
| ----------------- | ----------------------------- |
| Revenue           | SUM(PAYMENT_VALUE)            |
| Orders            | COUNT(DISTINCT ORDER_ID)      |
| Customers         | COUNT(DISTINCT CUSTOMER_ID)   |
| AOV               | Revenue / Orders              |
| Avg Review Score  | AVG(REVIEW_SCORE)             |
| Avg Delivery Days | AVG(DELIVERY_DAYS)            |
| CLV               | Customer Revenue Contribution |

---

# 📊 Tableau Dashboards

# Dashboard 1 — Executive Performance Dashboard

### Objectives

Provide executives with a complete overview of business performance.

### KPIs

* Revenue
* Orders
* Customers
* Average Order Value
* Average Review Score
* Average Delivery Days

### Visualizations

* Monthly Revenue Trend
* Revenue by State
* Revenue by City
* Payment Method Analysis

### Screenshot

<img width="3198" height="1798" alt="Dashboard 1" src="https://github.com/user-attachments/assets/db567647-d38c-4929-95e3-75a02b85ca7b" />


---

# Dashboard 2 — Products & Operations Dashboard

### Objectives

Analyze product performance and operational efficiency.

### Visualizations

* Review Distribution
* Delivery Impact on Reviews
* Installment Analysis
* Best Selling Categories
* Product Category Revenue
* Top Seller Performance

### Screenshot

<img width="3198" height="1798" alt="Dashboard 2" src="https://github.com/user-attachments/assets/b9fa6f52-4f9b-4318-b256-c3a3713819d2" />


---

# Dashboard 3 — Customer & Geographic Insights Dashboard

### Objectives

Analyze customer behavior, loyalty, and geographical trends.

### Visualizations

* Customer Engagement Analysis
* Customer Lifetime Value
* Repeat Customer Analysis
* Customer Satisfaction Score
* Top Revenue States
* Top Seller States

### Screenshot

<img width="2730" height="1534" alt="Dashboard 3" src="https://github.com/user-attachments/assets/877fbf11-c80d-4f2a-89ae-be404029bddf" />


---

# ☁️ AWS S3 Integration

Amazon S3 was used as the cloud storage layer for raw datasets.
Applied a 9-category data quality framework across all 10 staging tables in Amazon Athena (90 total checks), validating schema integrity, completeness, content validity, and ETL load accuracy before data was promoted to Snowflake.

### AWS Screenshots
<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/8fa61ae1-9cea-496c-8dd6-78dfa0e15c9a" />


<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/9f05cebf-9794-4abf-a6a2-a27e275df5da" />


<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/cf35ba21-1308-4214-b4e3-3fe6c081aad2" />

<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/d383f889-684b-4c5d-a23a-eeffdcb03241" />

<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/198a0584-1bce-465a-9d28-fc38064ee296" />

<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/33224184-78f6-410e-bf1c-2ad3c46efe69" />


---

# ❄️ Snowflake Data Warehouse

Snowflake served as the centralized analytics warehouse.

### Snowflake Screenshots

<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/f826f730-2139-4546-aef1-cd021fba3e7b" />


<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/f0cac66d-566e-445b-b414-98829090fc3d" />


<img width="2560" height="1600" alt="image" src="https://github.com/user-attachments/assets/f1fe83f9-7b53-4e14-922f-46f1cb5e4f71" />


---

# 💡 Key Business Insights

## Revenue Insights

* São Paulo generated the highest revenue across all states.
* Revenue demonstrated consistent growth over time.
* Major cities contributed disproportionately to total revenue.

## Customer Insights

* Positive reviews dominated customer feedback.
* Late deliveries significantly reduced customer ratings.
* Repeat customers generated higher lifetime value.

## Product Insights

* Beauty & Health generated the highest revenue.
* Bed, Bath & Table achieved the highest sales volume.

## Payment Insights

* Credit Card dominated payment transactions.
* Most customers preferred fewer installments.

## Seller Insights

* Revenue was concentrated among a small group of sellers.
* Seller activity was heavily concentrated in a few states.

---

# 🚀 Skills Demonstrated

### Data Engineering

* AWS S3
* Snowflake
* Data Warehousing
* Data Modeling

### Data Analytics

* SQL
* Feature Engineering
* KPI Development
* Business Analysis

### Visualization

* Tableau Dashboard Design
* Interactive Filters
* Geographic Analysis
* Executive Reporting

---

# 📚 Future Enhancements

* Real-Time Data Pipeline
* Automated Dashboard Refresh
* Predictive Sales Forecasting
* Customer Churn Prediction
* Product Recommendation Engine
* Advanced Customer Segmentation

---

# 👨‍💻 Author

## Yash Malviya

**Aspiring Data Analyst | SQL | Python | Snowflake | AWS | Tableau**

### Connect With Me

* LinkedIn: https://www.linkedin.com/in/yash-malviya-03433b258/
* Tableau Public: https://public.tableau.com/app/profile/yash.malviya6387/vizzes
* GitHub: https://github.com/YashMalviya01

---

## ⭐ If you found this project useful, consider giving it a star!
