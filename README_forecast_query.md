# App Review Forecast Query Documentation

## Overview
This query generates comprehensive metrics for forecasting your app review team operations, matching the dashboard structure shown in your forecast image.

## Key Metrics Generated

### Core Submission Metrics
- **app_submission_first**: First submissions (`is_first_submission_review = TRUE` AND `latest_review_state = 'SUBMITTED'`)
- **app_submission_re**: Resubmissions (`is_first_submission_review = FALSE` AND `latest_review_state = 'SUBMITTED'`)
- **app_submission_total**: Total submissions (first + resubmissions)
- **app_publish**: Approved submissions (`latest_review_state = 'APPROVED'`)
- **avg_time_to_publish_days**: Average days from submission to approval

### Headcount Metrics
- **headcount_taskus**: Unique reviewers where `review_tier != 'Internal'`
- **headcount_internal**: Unique reviewers where `review_tier = 'Internal'`
- **headcount_total**: All unique reviewers

### Productivity Metrics
- **submissions_per_head_taskus**: Total submissions / TaskUs headcount
- **submissions_per_head_total**: Total submissions / Total headcount
- **submissions_per_head_internal**: Total submissions / Internal headcount

### Capacity Metrics
- **taskus_monthly_screening_capacity**: TaskUs headcount × 45 screenings/month
- **internal_monthly_screening_capacity**: Internal headcount × 18 screenings/month
- **forecasted_screenings_per_submission**: Estimated at 1.7 screenings per submission

### SLA Targets (Based on Dashboard)
- TaskUs Overall: 760 hours/week, 855 screenings/month, 90 quality score
- Internal Overall: 240 hours/week, 108 screenings/month
- TaskUs Individual: 45 screenings/month, 90 quality score
- Internal Individual: 18 screenings/month

## Usage Instructions

### 1. Basic Execution
Run the query as-is to get monthly metrics from January 2023 onwards:

```sql
-- The main query in app_review_forecast_query.sql
```

### 2. Filtering by Date Range
To focus on specific periods, modify the WHERE clause:

```sql
WHERE submission_month >= '2024-01-01' 
  AND submission_month <= '2024-12-31'
```

### 3. Adding Forecast Data
To extend with 2025 forecasts (like your dashboard), you can UNION with forecast data:

```sql
-- Add this after the main query
UNION ALL
SELECT 
  submission_month,
  -- Add your 2025 forecast values here
FROM (
  SELECT 
    DATE('2025-01-01') as submission_month,
    495 as app_submission_first,
    -- etc.
)
```

### 4. Customizing SLA Targets
Modify the `sla_metrics` CTE to adjust targets:

```sql
-- Update these values based on current targets
760 AS taskus_hours_per_week_target,
240 AS internal_hours_per_week_target,
-- etc.
```

## Key Assumptions

1. **Reviewer Assignment**: Uses the first reviewer in the `reviewers` array
2. **Screening Ratio**: Assumes 1.7 screenings per submission
3. **Monthly Capacity**: TaskUs = 45, Internal = 18 screenings per person
4. **Time to Publish**: Calculated as days between `submitted_at` and `approved_at`

## Extending the Query

### Adding Squad-Level Metrics
```sql
-- Add to monthly_submissions CTE
COUNT(DISTINCT CASE WHEN squad_code = 'JFG' THEN reviewed_by END) AS jfg_headcount,
COUNT(DISTINCT CASE WHEN squad_code = 'MAN' THEN reviewed_by END) AS man_headcount,
-- etc.
```

### Adding Quality Metrics
```sql
-- Add screening success rates
AVG(SAFE_DIVIDE(passed_screening_criterion_count, assessed_screening_criterion_count)) AS avg_screening_pass_rate,
```

### Adding Complexity Analysis
```sql
-- Add app type complexity
COUNT(CASE WHEN 'public' IN UNNEST(app_store_app_submission_app_types) THEN 1 END) AS public_app_submissions,
COUNT(CASE WHEN 'custom' IN UNNEST(app_store_app_submission_app_types) THEN 1 END) AS custom_app_submissions,
```

## Output Format
The query returns monthly aggregated data with:
- Date columns: `submission_month`, `year`, `month`, `month_name`
- All metrics described above
- Performance vs target percentages
- Ordered chronologically from 2023 onwards

## Next Steps
1. Run the query to validate data accuracy
2. Compare results with your existing dashboard
3. Adjust SLA targets and assumptions as needed
4. Add forecast rows for future planning
5. Create visualizations using your preferred BI tool

