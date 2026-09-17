# Tableau dashboard specification

## Recommended title

**2Market customer sales and advertising conversions**

## Dashboard layout

### Summary row

- Customers
- Total sales
- Average sales per customer
- Customers with at least one successful conversion

### Main views

1. Product sales and share of total
2. Country sales with customer count and sales per customer in the tooltip
3. Customer distribution and sales by age group
4. Successful conversions by platform
5. Country-by-platform conversion heatmap

## Filters

- Country
- Product
- Age group
- Marital status

Filters should apply consistently to relevant views. The dashboard should not imply that product spending was caused by a particular advertising channel.

## Correct platform design

Do not use a calculated field with sequential `IF/ELSEIF` logic to assign each customer to one platform. That approach hides secondary conversions when more than one platform equals 1.

Instead, pivot these fields to rows:

- `Twitter_ad`
- `Instagram_ad`
- `Facebook_ad`

Rename the pivoted columns:

- `Platform`
- `Successful conversion`

Filter `Successful conversion = 1`, then count distinct customer IDs by platform.

## Recommended calculated fields

### Total sales

```text
[AmtLiq] + [AmtVege] + [AmtNonVeg] +
[AmtPes] + [AmtChocolates] + [AmtComm]
```

### Sales per customer

```text
SUM([Total sales]) / COUNTD([ID])
```

### Age at reference year

```text
IF [Year_Birth] >= 1940 AND [Year_Birth] <= 2005
THEN 2025 - [Year_Birth]
END
```

### Customer has a successful conversion

```text
IF [Count_success] > 0 THEN "Converted" ELSE "No recorded conversion" END
```

## Design notes

- Use one accent colour and neutral comparison colours.
- Sort bars by value.
- Display totals and normalized metrics together where market sizes differ.
- Place sample size in tooltips.
- Add a visible note that advertising exposure and spend are unavailable.
- Suppress or flag groups with fewer than 30 customers in decision-facing comparisons.

