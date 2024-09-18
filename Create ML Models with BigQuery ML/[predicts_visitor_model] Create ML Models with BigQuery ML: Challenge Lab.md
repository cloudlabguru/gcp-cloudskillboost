## Create ML Models with BigQuery ML: Challenge Lab [SOLUTION]
This guide is for ```predicts_visitor_model```, please read your instruction lab task 2 carefully <br/>
If you have to make ```customer_classification_model``` please move to [this guide lab](https://github.com/cloudlabguru/gcp-cloudskillboost/blob/main/Create%20ML%20Models%20with%20BigQuery%20ML/%5Bcustomer_classification_model%5D%20Create%20ML%20Models%20with%20BigQuery%20ML_%20Challenge%20Lab.md)

### Task 1. Create a new dataset
* Open BigQuery
* Create dataset ```bq_dataset```

### Task 2. Create and evaluate a model
Run this script in BigQuery Editor
```sql
CREATE OR REPLACE MODEL `bqml_dataset.predicts_visitor_model`
OPTIONS(model_type='logistic_reg') AS
SELECT
  IF(totals.transactions IS NULL, 0, 1) AS label,
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(geoNetwork.country, '') AS country,
  IFNULL(totals.pageviews, 0) AS pageviews
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20160801' AND '20170631'
LIMIT 100000;
```
and this script
```sql
#standardSQL
SELECT
  *
FROM
  ml.EVALUATE(MODEL `bqml_dataset.predicts_visitor_model`, (
SELECT
  IF(totals.transactions IS NULL, 0, 1) AS label,
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(geoNetwork.country, '') AS country,
  IFNULL(totals.pageviews, 0) AS pageviews
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'));
```

### Task 3. Use the model to predict purchases per country
Run this script in BigQuery Editor
```sql
#standardSQL
SELECT
  country,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL `bqml_dataset.predicts_visitor_model`, (
SELECT
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, '') AS country
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY country
ORDER BY total_predicted_purchases DESC
LIMIT 10;
```

### Task 4. Use the model to predict purchases per user
Run this script in BigQuery Editor
```sql
#standardSQL
SELECT
  fullVisitorId,
  SUM(predicted_label) as total_predicted_purchases
FROM
  ml.PREDICT(MODEL `bqml_dataset.predicts_visitor_model`, (
SELECT
  IFNULL(device.operatingSystem, '') AS os,
  device.isMobile AS is_mobile,
  IFNULL(totals.pageviews, 0) AS pageviews,
  IFNULL(geoNetwork.country, '') AS country,
  fullVisitorId
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`
WHERE _TABLE_SUFFIX BETWEEN '20170701' AND '20170801'))
GROUP BY fullVisitorId
ORDER BY total_predicted_purchases DESC
LIMIT 10;
```

## Congratulations !! 
