-- 2Market portfolio project
-- Author: Solomon Alfred
-- PostgreSQL schema. Source files are excluded from the public repository.

DROP TABLE IF EXISTS ad_data;
DROP TABLE IF EXISTS marketing_data;

CREATE TABLE marketing_data (
    id              BIGINT PRIMARY KEY,
    year_birth      INTEGER,
    education       VARCHAR(50),
    marital_status  VARCHAR(20),
    income          NUMERIC(12, 2),
    kidhome         INTEGER,
    teenhome        INTEGER,
    dt_customer     DATE,
    recency         INTEGER,
    amt_liq         NUMERIC(12, 2),
    amt_vege        NUMERIC(12, 2),
    amt_nonveg      NUMERIC(12, 2),
    amt_pes         NUMERIC(12, 2),
    amt_chocolates  NUMERIC(12, 2),
    amt_comm        NUMERIC(12, 2),
    num_deals       INTEGER,
    num_web_buy     INTEGER,
    num_walkin_pur  INTEGER,
    num_visits      INTEGER,
    response        INTEGER,
    complain        INTEGER,
    country         VARCHAR(10),
    count_success   INTEGER
);

CREATE TABLE ad_data (
    id            BIGINT PRIMARY KEY,
    bulkmail_ad   INTEGER,
    twitter_ad    INTEGER,
    instagram_ad  INTEGER,
    facebook_ad   INTEGER,
    brochure_ad   INTEGER
);

-- Load authorized source files locally. Do not commit them.
-- Example for psql; update the paths before running:
-- \copy marketing_data FROM 'data/raw/marketing_data.csv' CSV HEADER;
-- \copy ad_data FROM 'data/raw/ad_data.csv' CSV HEADER;

