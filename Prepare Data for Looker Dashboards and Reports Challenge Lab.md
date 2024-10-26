## Prepare Data for Looker Dashboards and Reports: Challenge Lab [SOLUTION]

You need to follow the instructions from the tutorial video

### Task 1 Look#1
Add this following command in faa.model
```
explore: +airports {
     query: start_from_here{
      dimensions: [city, state]
      measures: [count]
      filters: [airports.facility_type: "HELIPORT^ ^ ^ ^ ^ ^ ^ "]
    } 
}
```

### Task 1 Look#2
Replace the previous command with this following command in faa.model
```
explore: +airports {
    query: start_from_here{
      dimensions: [facility_type, state]
      measures: [count]
    }
  }

```

### Task 1 Look#3
Replace the previous command with this following command in faa.model
```
explore: +flights {
    query: start_from_here{
      dimensions: [aircraft_origin.city, aircraft_origin.state]
      measures: [cancelled_count, count]
    }
}
```

## Congratulations !! 
