# US Car Sales 2019 — Data Analysis Project (CodersLab Bootcamp)

Small end-to-end data analysis project completed as part of the **CodersLab Data Science / Data Analysis** course.  
Goal: explore and explain patterns in **cars sold in the United States in 2019** using a dataset with **31 features** (price, horsepower, model year, brand, etc.).

---

## 1) Problem Framing

### Business question
We want to understand the 2019 US automotive market:
- What does the **price distribution** look like?
- What are the **most expensive cars**, and who makes them?
- How do prices differ by **manufacturer / model year**?
- Is there a relationship between **engine power (hp)** and **price**?

### Hypothesis examples
- **Higher hp → higher price** (positive association)
- Prices are **right-skewed** due to luxury outliers
- Model year influences the distribution of sales

---

## 2) Data Collection

### Sources
The dataset was provided in the bootcamp materials and complemented with:
- official documentation / variable descriptions
- domain notes (automotive market basics) for interpretation


---

## 3) Data Understanding

The dataset contains **31 variables**, including:
- `msrp` (price)
- `make` (manufacturer)
- `model` (full model name)
- `year` (model year)
- `hp` (engine power)
- other technical / categorical descriptors

---

## 4) Data Cleaning & Processing (Excel)

Key cleaning steps:
- Checked data types (numeric vs text)
- Detected missing / invalid values (e.g., blanks, zeros where not meaningful)
- Identified extreme values and confirmed they are **outliers** (not errors)
- Standardized formatting (currency, commas/decimals)
- Created helper columns for grouping (bins / categories)

Tools used:
- `COUNT`, `COUNTA`, `COUNTIF(S)`
- `AVERAGE`, `MEDIAN`, `MIN`, `MAX`
- `QUARTILE.INC`, `PERCENTILE.INC`, `IQR`
- Filters & sorting

---

## 5) Exploratory Data Analysis (EDA)

### Task 1 — Basic descriptive statistics for price (`msrp`)
Calculated:
- count, min, max, average, median
- Q1, Q3, IQR
- standard deviation and variance  
Interpreted skewness: **mean > median** → prices are **right-skewed** due to high-end outliers.

### Task 2 — Most expensive car
Identified:
- maximum `msrp`
- corresponding `make` and full `model` name  
Validated the record with filtering and row inspection.

### Task 3 — Price distribution for a chosen manufacturer
Example: **Audi**  
Created a histogram with bin width adjustments to show:
- concentration of typical prices
- long right tail due to premium models

### Task 4 — Sales share by model year (percent)
Used Pivot Table to compute:
- counts by `year`
- % of total sales by year  
Presented as a percentage-based summary chart.

### Task 5 — Relationship between hp and price
Created scatter plot:
- X-axis: `hp`
- Y-axis: `msrp`
Computed:
- Pearson correlation (`CORREL`)
- linear trendline with equation and **R²**  
Conclusion:
- **moderate positive correlation** (cars with higher hp tend to be more expensive)
- R² shows hp explains only part of price variation → other factors matter (brand, trim, year, features).

---

## 6) Pivot Tables Used

Pivot tables were used to:
- summarize counts and percentages by categories (year, manufacturer)
- avoid manual grouping for large datasets
- quickly validate distributions and outlier counts

Common setup patterns:
- Rows: `year` / `make`
- Values: count of records
- Show values as: % of grand total (for sales share)

---

## 7) Key Insights (Summary)

- Vehicle prices show **strong right skew**: most cars are in a moderate price band, while luxury vehicles create extreme upper outliers.
- The most expensive listing is a clear **luxury outlier** and heavily influences the mean.
- Manufacturer-level distributions differ: premium brands show higher price ranges and heavier tails.
- Horsepower and price have a **moderate positive relationship**, but hp alone cannot explain most price differences.

---

## 8) Deliverables

- Descriptive statistics table (price)
- Boxplot for `msrp` with quartiles and outliers
- Histogram for a selected manufacturer (e.g., Audi)
- Pivot summary: sales distribution by model year (%)
- Scatter plot: `hp` vs `msrp` + trendline + correlation

---

## 9) How to Reproduce

1. Open the dataset in Excel.
2. Confirm numeric columns are stored as numbers (not text).
3. Compute descriptive statistics for `msrp` (including quartiles/IQR).
4. Filter to find max `msrp` and read `make` + `model`.
5. Create a histogram for one manufacturer (filter by `make`).
6. Build pivot table for model year counts and percentages.
7. Create scatter plot (`hp` vs `msrp`) and add trendline + R².
8. Compute Pearson correlation using `=CORREL(hp_range, price_range)`.

---

## 10) Notes / Improvements

Possible next steps:
- multiple regression (hp, year, mileage-like variables, brand dummies)
- log-transform price to reduce skewness
- outlier handling strategy (winsorizing / robust metrics)
- segment analysis by brand class (economy vs premium)

---

**Course:** CodersLab Bootcamp — Data Analysis / Data Science  
**Author:** Uroš Vukmanović
