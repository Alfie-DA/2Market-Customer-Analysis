# Methodology

## Scope

This case study analyses customer demographics, customer-level product spending, and recorded successful advertising conversions. It does not measure profitability or advertising return on investment.

## Reproducible age definition

The original workbook used `YEAR(TODAY()) - Year_Birth`, which changes whenever the file is opened in a new year. The portfolio analysis fixes the reference year at 2025:

```text
age_at_2025 = 2025 - Year_Birth
```

The three implausible birth years are retained in the raw data but excluded from age calculations. This preserves an audit trail and avoids discarding unrelated spending or conversion information.

## Sales definition

Total customer sales are the sum of:

- alcoholic beverages;
- vegetables;
- non-vegetable products;
- fish products;
- chocolates; and
- commodities.

No costs or margins are present, so “profit,” “profitable product,” and “profitable customer” are not used.

## Advertising definition

Each advertising field is a binary indicator that a successful conversion was recorded for a customer. Counts are calculated independently by platform because one customer may have multiple successful channel indicators.

The data does not provide the number of people exposed to each channel. A platform with more conversions may simply have reached more people. The analysis therefore uses “recorded successful conversions,” not “conversion rate” or “most effective platform.”

## Country comparisons

Country performance is reported using:

- number of customers;
- total sales; and
- average sales per customer.

This prevents a large customer base from being mistaken for unusually high customer value. Results for very small countries are clearly flagged.

## Tools

- **Excel:** initial inspection, filtered analysis, and exploratory visualisation
- **PostgreSQL:** validation, reshaping, aggregation, and ranking
- **Tableau:** interactive presentation of aggregate results

## Quality controls

The SQL workflow checks duplicate IDs, missing IDs, unmatched customers, invalid binary values, birth-year ranges, successful-conversion reconciliation, and row counts after joining.

