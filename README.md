# Data notes

The original files are intentionally excluded because Solomon Alfred does not hold redistribution rights for the course dataset.

## Expected inputs

### `marketing_data.csv`

One row per customer. Expected fields include customer ID, year of birth, education, marital status, annual income, household composition, registration date, recency, six product-spending fields, purchase-channel activity, campaign response, complaints, country, and successful-conversion count.

### `ad_data.csv`

One row per customer. Expected fields are customer ID and five binary successful-conversion indicators: bulk email, Twitter, Instagram, Facebook, and brochure.

## Grain and relationship

- `marketing_data`: one row per customer ID
- `ad_data`: one row per customer ID
- relationship: one-to-one on customer ID in the supplied analysis files

Validate that relationship before running the analytical queries. A many-to-many join would duplicate spending values and invalidate totals.

## Reproduction

Place authorized copies of the two CSV files in a local `data/raw/` directory. Do not commit that directory. Run the SQL files in numerical order and adjust the `COPY` paths for the local environment.

## Data-quality rules

- Preserve source rows in the raw layer.
- Treat birth years 1894, 1900, and 1901 as invalid for age calculations; do not silently delete their non-age information.
- Use 2025 as the documented age reference year for this case study.
- Confirm that binary columns contain only 0 and 1.
- Confirm that customer IDs are non-null, unique, and shared between both inputs.
- Treat product fields as sales amounts, not profit.

