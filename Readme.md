# Python/Pandas/SQL data ETL transformation scripts

Simple scripts for data cleaning, etl transformations and data reorganisations.
Data model is built on star schema where is one main dimension table and a lot
of smaller fact tables.

These scripts are written in:

1. Pandas
2. Snowflake

You can find here transformations:

1. SLA predictions for deliveries
2. Data mapping for web statuses
3. Data mapping for administration statuses
4. Data mapping for Tableau
5. Identify non delivered orders
6. Identify delayed orders
7. Merging all SLA dates and states into one table
8. Get final states based on a dates or order
9. Transform excel columns to rows based on specified rules
10. Trigger on data update

These scripts running in
[Keboola Connection platform](https://www.keboola.com/).
