## Create ML Models with BigQuery ML: Challenge Lab [SOLUTION]
This guide is for ```austin_location_model```, please read your instruction lab task 2 carefully <br/>
If you have to make ```predicts_visitor_model``` please move to [this guide lab](https://github.com/cloudlabguru/gcp-cloudskillboost/blob/main/Create%20ML%20Models%20with%20BigQuery%20ML/%5Bpredicts_visitor_model%5D%20Create%20ML%20Models%20with%20BigQuery%20ML%3A%20Challenge%20Lab.md) <br/>
If you have to make ```customer_classification_model``` please move to [this guide lab](https://github.com/cloudlabguru/gcp-cloudskillboost/blob/main/Create%20ML%20Models%20with%20BigQuery%20ML/%5Bcustomer_classification_model%5D%20Create%20ML%20Models%20with%20BigQuery%20ML_%20Challenge%20Lab.md)

### Task 1. Create a new dataset
* Open BigQuery
* Create dataset ```bq_dataset```

### Task 2. Create a forecasting BigQuery machine learning model
Run this script in BigQuery Editor
```sql
CREATE OR REPLACE MODEL austin.austin_location_model
OPTIONS (
  model_type='linear_reg',
  labels=['duration_minutes']
) AS
SELECT
  start_station_name,
  EXTRACT(HOUR FROM start_time) AS start_hour,
  EXTRACT(DAYOFWEEK FROM start_time) AS day_of_week,
  duration_minutes,
  address AS location
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS trips
JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS stations
ON
  trips.start_station_name = stations.name
WHERE
  EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR
  AND duration_minutes > 0;
;
```

### Task 3. Evaluate the machine learning models
Run this script in BigQuery Editor
```sql
SELECT
  SQRT(mean_squared_error) AS rmse,
  mean_absolute_error
FROM
  ML.EVALUATE(MODEL austin.austin_location_model, (
  SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    EXTRACT(DAYOFWEEK FROM start_time) AS day_of_week,
    duration_minutes,
    address AS location
  FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` AS trips
  JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS stations
  ON
    trips.start_station_name = stations.name
  WHERE EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR)
)
;
```

### Task 4. Use the subscriber type machine learning model to predict average trip durations
Run this script in BigQuery Editor
```sql
SELECT AVG(predicted_duration_minutes) AS average_predicted_trip_length
FROM ML.predict(MODEL austin.subscriber_model, (
SELECT
    start_station_name,
    EXTRACT(HOUR FROM start_time) AS start_hour,
    subscriber_type,
    duration_minutes
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips`
WHERE
  EXTRACT(YEAR FROM start_time) = $EVALUATION_YEAR
  AND subscriber_type = 'Single Trip'
  AND start_station_name = '21st & Speedway @PCL'));
```

## Congratulations !! 
