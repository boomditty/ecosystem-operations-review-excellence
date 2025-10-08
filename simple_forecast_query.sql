-- Simple App Review Forecast Query - Maximum BigQuery Compatibility

-- Historical actuals
SELECT 
  DATE_TRUNC(submitted_at, MONTH) AS submission_month,
  EXTRACT(YEAR FROM DATE_TRUNC(submitted_at, MONTH)) AS year,
  EXTRACT(MONTH FROM DATE_TRUNC(submitted_at, MONTH)) AS month,
  FORMAT_DATE('%B', DATE_TRUNC(submitted_at, MONTH)) AS month_name,
  'Actual' AS data_type,
  
  -- Core metrics
  COUNT(CASE WHEN is_first_submission_review = TRUE AND latest_review_state = 'SUBMITTED' THEN app_store_app_submission_review_id END) AS app_submission_first,
  COUNT(CASE WHEN is_first_submission_review = FALSE AND latest_review_state = 'SUBMITTED' THEN app_store_app_submission_review_id END) AS app_submission_re,
  COUNT(CASE WHEN latest_review_state = 'SUBMITTED' THEN app_store_app_submission_review_id END) AS app_submission_total,
  COUNT(DISTINCT CASE WHEN latest_review_state = 'APPROVED' THEN app_store_app_submission_review_id END) AS app_publish,
  
  -- Simplified headcount (you'll need to adjust these based on your actual data)
  19 AS headcount_taskus,  -- Use your actual TaskUs headcount or calculate from reviewers array
  6 AS headcount_internal,  -- Use your actual Internal headcount
  25 AS headcount_total,
  
  AVG(CASE WHEN approved_at IS NOT NULL AND submitted_at IS NOT NULL 
      THEN DATETIME_DIFF(approved_at, submitted_at, DAY) END) AS avg_time_to_publish_days

FROM `shopify-dw.apps_and_developers.app_store_app_submission_reviews_v1`
WHERE submitted_at >= '2023-01-01' AND submitted_at < '2025-01-01'
GROUP BY DATE_TRUNC(submitted_at, MONTH)

UNION ALL

-- 2025 Forecast
SELECT 
  DATE(submission_month) AS submission_month,
  EXTRACT(YEAR FROM DATE(submission_month)) AS year,
  EXTRACT(MONTH FROM DATE(submission_month)) AS month,
  FORMAT_DATE('%B', DATE(submission_month)) AS month_name,
  'Forecast' AS data_type,
  
  app_submission_first,
  app_submission_re,
  app_submission_total,
  app_publish,
  19 AS headcount_taskus,
  6 AS headcount_internal,
  25 AS headcount_total,
  CAST(NULL AS FLOAT64) AS avg_time_to_publish_days

FROM UNNEST([
  STRUCT('2025-01-01' AS submission_month, 495 AS app_submission_first, 99 AS app_submission_re, 594 AS app_submission_total, 495 AS app_publish),
  STRUCT('2025-02-01', 577, 115, 692, 577),
  STRUCT('2025-03-01', 591, 118, 709, 591),
  STRUCT('2025-04-01', 500, 100, 600, 500),
  STRUCT('2025-05-01', 517, 103, 620, 517),
  STRUCT('2025-06-01', 521, 104, 625, 521),
  STRUCT('2025-07-01', 637, 127, 764, 637),
  STRUCT('2025-08-01', 691, 138, 829, 691),
  STRUCT('2025-09-01', 725, 145, 870, 725),
  STRUCT('2025-10-01', 632, 126, 758, 632),
  STRUCT('2025-11-01', 738, 148, 886, 738),
  STRUCT('2025-12-01', 497, 99, 596, 497)
])

ORDER BY submission_month;

