-- Forecast Extension Example
-- This shows how to add 2025 forecast data to match your dashboard

-- Add this UNION ALL section after your main query to include 2025 forecasts
UNION ALL

-- 2025 Forecast Data (from your dashboard image)
SELECT 
  DATE(submission_month) AS submission_month,
  EXTRACT(YEAR FROM DATE(submission_month)) AS year,
  EXTRACT(MONTH FROM DATE(submission_month)) AS month,
  FORMAT_DATE('%B', DATE(submission_month)) AS month_name,
  
  -- 2025 Forecast values from your dashboard
  app_submission_first,
  app_submission_re,
  app_submission_total,
  app_publish,
  NULL AS avg_time_to_publish_days, -- Forecast placeholder
  
  -- Staffing Plan values
  19 AS headcount_taskus,   -- 2025 Staffing TaskUs Plan
  6 AS headcount_internal,  -- 2025 Internal Staffing Plan  
  25 AS headcount_total,    -- Combined
  
  -- Productivity metrics (calculated)
  ROUND(SAFE_DIVIDE(app_submission_total, 19), 1) AS submissions_per_head_taskus,
  ROUND(SAFE_DIVIDE(app_submission_total, 25), 1) AS submissions_per_head_total,
  ROUND(SAFE_DIVIDE(app_submission_total, 6), 1) AS submissions_per_head_internal,
  
  -- Capacity metrics
  19 * 45 AS taskus_monthly_screening_capacity,
  6 * 18 AS internal_monthly_screening_capacity,
  ROUND(app_submission_total * 1.7, 0) AS forecasted_screenings_per_submission,
  
  -- SLA targets (same as current)
  760 AS taskus_hours_per_week_target,
  240 AS internal_hours_per_week_target,
  855 AS taskus_screenings_per_month_target,
  108 AS internal_screenings_per_month_target,
  90 AS quality_per_month_target,
  45 AS taskus_individual_monthly_screenings_target,
  90 AS taskus_individual_quality_score_target,
  18 AS internal_individual_monthly_screenings_target,
  
  -- Performance vs targets
  ROUND(SAFE_DIVIDE(19 * 45, 855) * 100, 1) AS taskus_capacity_vs_target_pct,
  ROUND(SAFE_DIVIDE(6 * 18, 108) * 100, 1) AS internal_capacity_vs_target_pct

FROM UNNEST([
  -- January 2025
  STRUCT('2025-01-01' AS submission_month, 495 AS app_submission_first, 
         CAST(495 * 0.2 AS INT64) AS app_submission_re, 594 AS app_submission_total, 495 AS app_publish),
  
  -- February 2025  
  STRUCT('2025-02-01', 577, CAST(577 * 0.2 AS INT64), 692, 577),
  
  -- March 2025
  STRUCT('2025-03-01', 591, CAST(591 * 0.2 AS INT64), 709, 591),
  
  -- April 2025
  STRUCT('2025-04-01', 500, CAST(500 * 0.2 AS INT64), 600, 500),
  
  -- May 2025
  STRUCT('2025-05-01', 517, CAST(517 * 0.2 AS INT64), 620, 517),
  
  -- June 2025
  STRUCT('2025-06-01', 521, CAST(521 * 0.2 AS INT64), 625, 521),
  
  -- July 2025
  STRUCT('2025-07-01', 637, CAST(637 * 0.2 AS INT64), 764, 637),
  
  -- August 2025
  STRUCT('2025-08-01', 691, CAST(691 * 0.2 AS INT64), 829, 691),
  
  -- September 2025
  STRUCT('2025-09-01', 725, CAST(725 * 0.2 AS INT64), 870, 725),
  
  -- October 2025
  STRUCT('2025-10-01', 632, CAST(632 * 0.2 AS INT64), 758, 632),
  
  -- November 2025
  STRUCT('2025-11-01', 738, CAST(738 * 0.2 AS INT64), 886, 738),
  
  -- December 2025
  STRUCT('2025-12-01', 497, CAST(497 * 0.2 AS INT64), 596, 497)
])

ORDER BY submission_month;

