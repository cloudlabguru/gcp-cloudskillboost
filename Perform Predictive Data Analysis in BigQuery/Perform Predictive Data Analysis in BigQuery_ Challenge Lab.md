## Perform Predictive Data Analysis in BigQuery: Challenge Lab [SOLUTION]

### Task 1. Data ingestion
* Open BigQuery
* On "soccer" dataset, create 2 new tables from the instruction lab

### Task 2-5
Copy to notepad and fill this value given by the instruction lab
```
$EVENT_TABLE=
$X1=
$Y1=
$X2=
$Y2=
$FUNC1=
$FUNC2=
$MODEL=
```
Replace all the above variable (including $) with the given value, you can use this [website](https://www.browserling.com/tools/text-replace) <br />
Run this script in BigQuery Editor
```sql
-- TASK 2
SELECT
  playerId,
  (Players.firstName || ' ' || Players.lastName) AS playerName,
  COUNT(id) AS numPKAtt,
  SUM(IF(101 IN UNNEST(tags.id), 1, 0)) AS numPKGoals,
  SAFE_DIVIDE(
    SUM(IF(101 IN UNNEST(tags.id), 1, 0)),
    COUNT(id)
  ) AS PKSuccessRate
FROM `soccer.$EVENT_TABLE` Events
LEFT JOIN `soccer.players` Players
ON Events.playerId = Players.wyId
WHERE
  eventName = 'Free Kick' AND
  subEventName = 'Penalty'
GROUP BY playerId, playerName
HAVING numPkAtt >= 5
ORDER BY PKSuccessRate DESC, numPKAtt DESC
;

-- TASK 3
WITH Shots AS (
  SELECT
  *,
  /* Tag 101 represents a goal using the table */
  (101 IN UNNEST(tags.id)) AS isGoal,
  /* Translate 0-100 (x,y) coordinate-based distances to absolute positions
  using "average" field dimensions of 105x68 before combining in 2D dist calc */
  SQRT(
  POW(
    (100 - positions[ORDINAL(1)].x) * $X1/$Y1,
    2) +
  POW(
    (60 - positions[ORDINAL(1)].y) * $X2/$Y2,
    2)
   ) AS shotDistance
  FROM `soccer.$EVENT_TABLE`
  WHERE
    /* Includes both "open play" & free kick shots (including penalties) */
    eventName = 'Shot' OR
    (eventName = 'Free Kick' AND
    subEventName IN ('Free kick shot', 'Penalty'))
)
SELECT
  ROUND(shotDistance, 0) AS ShotDistRound0,
  COUNT(*) AS numShots,
  SUM(IF(isGoal, 1, 0)) AS numGoals,
  AVG(IF(isGoal, 1, 0)) AS goalPct
FROM Shots
WHERE shotDistance <= 50
GROUP BY ShotDistRound0
ORDER BY ShotDistRound0
;

-- TASK 4
CREATE FUNCTION `$FUNC1`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 /* Translate 0-100 (x,y) coordinate-based distances to absolute positions
 using "average" field dimensions of X-axis lengthxY-axis length before combining in 2D dist calc */
 SQRT(
   POW(($X1 - x) * $X2/100, 2) +
   POW(($Y1 - y) * $Y2/100, 2)
   )
 );
CREATE FUNCTION `$FUNC2`(x INT64, y INT64)
RETURNS FLOAT64
AS (
 SAFE.ACOS(
   /* Have to translate 0-100 (x,y) coordinates to absolute positions using
   "average" field dimensions of X-axis lengthxY-axis length before using in various distance calcs */
   SAFE_DIVIDE(
     ( /* Squared distance between shot and 1 post, in meters */
       (POW($X2 - (x * $X2/100), 2) + POW($Y2/2 + (7.32/2) - (y * $Y2/100), 2)) +
       /* Squared distance between shot and other post, in meters */
       (POW($X2 - (x * $X2/100), 2) + POW($Y2/2 - (7.32/2) - (y * $Y2/100), 2)) -
       /* Squared length of goal opening, in meters */
       POW(7.32, 2)
     ),
     (2 *
       /* Distance between shot and 1 post, in meters */
       SQRT(POW($X2 - (x * $X2/100), 2) + POW($Y2/2 + 7.32/2 - (y * $Y2/100), 2)) *
       /* Distance between shot and other post, in meters */
       SQRT(POW($X2 - (x * $X2/100), 2) + POW($Y2/2 - 7.32/2 - (y * $Y2/100), 2))
     )
    )
  /* Translate radians to degrees */
  ) * 180 / ACOS(-1)
 )
;
CREATE MODEL `$MODEL`
OPTIONS(
model_type = 'LOGISTIC_REG',
input_label_cols = ['isGoal']
) AS
SELECT
Events.subEventName AS shotType,
  /* 101 is known Tag for 'goals' from goals table */
  (101 IN UNNEST(Events.tags.id)) AS isGoal,
  `$FUNC1`(Events.positions[ORDINAL(1)].x,
  Events.positions[ORDINAL(1)].y) AS shotDistance,
  `$FUNC2`(Events.positions[ORDINAL(1)].x,
  Events.positions[ORDINAL(1)].y) AS shotAngle
FROM `soccer.$EVENT_TABLE` Events
LEFT JOIN `soccer.matches` Matches
ON Events.matchId = Matches.wyId
LEFT JOIN `soccer.competitions` Competitions
ON Matches.competitionId = Competitions.wyId
WHERE
  /* Filter out World Cup matches for model fitting purposes */
  Competitions.name != 'World Cup' AND
  /* Includes both "open play" & free kick shots (including penalties) */
  (
  eventName = 'Shot' OR
  (eventName = 'Free Kick' AND subEventName IN ('Free kick shot', 'Penalty'))
  ) AND
  `$FUNC2`(Events.positions[ORDINAL(1)].x,
  Events.positions[ORDINAL(1)].y) IS NOT NULL
;

-- TASK 5
SELECT
  predicted_isGoal_probs[ORDINAL(1)].prob AS predictedGoalProb,
  * EXCEPT (predicted_isGoal, predicted_isGoal_probs),
FROM
  ML.PREDICT(
    MODEL `$MODEL`, 
    (
     SELECT
       Events.playerId,
       (Players.firstName || ' ' || Players.lastName) AS playerName,
       Teams.name AS teamName,
       CAST(Matches.dateutc AS DATE) AS matchDate,
       Matches.label AS match,
     /* Convert match period and event seconds to minute of match */
       CAST((CASE
         WHEN Events.matchPeriod = '1H' THEN 0
         WHEN Events.matchPeriod = '2H' THEN 45
         WHEN Events.matchPeriod = 'E1' THEN 90
         WHEN Events.matchPeriod = 'E2' THEN 105
         ELSE 120
         END) +
         CEILING(Events.eventSec / 60) AS INT64)
         AS matchMinute,
       Events.subEventName AS shotType,
       /* 101 is known Tag for 'goals' from goals table */
       (101 IN UNNEST(Events.tags.id)) AS isGoal,
     
       `$FUNC1`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotDistance,
       `$FUNC2`(Events.positions[ORDINAL(1)].x,
           Events.positions[ORDINAL(1)].y) AS shotAngle
     FROM `soccer.$EVENT_TABLE` Events
     LEFT JOIN `soccer.matches` Matches ON Events.matchId = Matches.wyId
     LEFT JOIN `soccer.competitions` Competitions ON Matches.competitionId = Competitions.wyId
     LEFT JOIN `soccer.players` Players ON Events.playerId = Players.wyId
     LEFT JOIN `soccer.teams` Teams ON Events.teamId = Teams.wyId
     WHERE
       /* Look only at World Cup matches to apply model */
       Competitions.name = 'World Cup' AND
       /* Includes both "open play" & free kick shots (but not penalties) */
       (
         eventName = 'Shot' OR
         (eventName = 'Free Kick' AND subEventName IN ('Free kick shot'))
       ) AND
       /* Filter only to goals scored */
       (101 IN UNNEST(Events.tags.id))
    )
  )
ORDER BY
predictedgoalProb
;
```

## Congratulations !! 
