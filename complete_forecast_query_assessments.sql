-- Complete App Review Forecast Query - Using Assessments Table
-- Combines historical data with 2025-2026 forecasts (24 months total)
-- Updated to use app_store_app_submission_review_assessments_v1

-- Reviewer metadata as a standalone CTE
WITH reviewer_metadata AS (
  SELECT * FROM UNNEST([
-- JFG Squad
STRUCT('Blue Bautista' AS reviewed_by, 'JFG' AS squad_code, 'Tier 2' AS review_tier, 'No' AS tier_2_audit, 'blue.bautista@shopify.com' AS email_address),
STRUCT('Camille Reyes','JFG','Tier 1','No','camille.delosreyes@shopify.com'),
STRUCT('Charl Tagalog','JFG','Tier 2','No','charl.tagalog@shopify.com'),
STRUCT('Dave Jor','JFG','Tier 2','No','dave.jor@shopify.com'),
STRUCT('Dominic Mostar','JFG','Tier 2','No','dominic.mostar@shopify.com'),
STRUCT('Earl Quiambao','JFG','Tier 1','No','earl.quiambao@shopify.com'),
STRUCT('Ericson Mendez','JFG','Tier 2','No','ericson.mendez@shopify.com'),
STRUCT('Ernel Ramos','JFG','Tier 2','No','ernel.ramos@shopify.com'),
STRUCT('Jeffrey Rozul','JFG','Tier 2','No','jeffrey.rozul@shopify.com'),
STRUCT('Joan Dizon','JFG','Tier 2','No','joan.dizon@shopify.com'),
STRUCT('Justine Lopez','JFG','Tier 2','No','justine.lopez02@shopify.com'),
STRUCT('Justine Nieva','JFG','Tier 2','No','justine.nieva@shopify.com'),
STRUCT('Kimberly Claire De Lena','JFG','Tier 2 - Audit','Yes','kimberly.delena@shopify.com'),
STRUCT('Liezl Punzalan','JFG','Tier 2','No','liezl.punzalan@shopify.com'),
STRUCT('Philip Pena','JFG','Tier 1','No','Philip.Pena@shopify.com'),
STRUCT('Ramil Dimacuha','JFG','Tier 2','No','ramil.dimacuha@shopify.com'),
STRUCT('Rommel Licup Jr','JFG','Tier 2','No','rommel.licup@shopify.com'),
STRUCT('Trace Pangan','JFG','Tier 2','No','trace.pangan@shopify.com'),
STRUCT('Von Mallari','JFG','Tier 2 - Audit','Yes','jonvonmallari.mallari@shopify.com'),
-- MAN Squad
STRUCT('Alden John Gonzales','MAN','Tier 2','No','alden.gonzales@shopify.com'),
STRUCT('Angela De Jesus','MAN','Tier 1','No','angela.dejesus@shopify.com'),
STRUCT('Bea Endozo','MAN','Tier 1','No','bea.endozo@shopify.com'),
STRUCT('Camille Cordova Carlos','MAN','Tier 2','No','camille.carlos@shopify.com'),
STRUCT('Camille Quizon','MAN','Tier 2','No','camille.quizon@shopify.com'),
STRUCT('Dave Vital','MAN','Tier 2','No','dave.vital@shopify.com'),
STRUCT('Dionard Badion','MAN','Tier 2','No','dionard.badion@shopify.com'),
STRUCT('Ednel Mercado','MAN','Tier 2','No','ednel.mercado@shopify.com'),
STRUCT('Jasper Agbanglo','MAN','Tier 2','No','jasper.agbanglo@shopify.com'),
STRUCT('Jefferson Anonas','MAN','Tier 2','No','jefferson.anonas@shopify.com'),
STRUCT('Jessierey Pascual','MAN','Tier 2','No','jessierey.pascual@shopify.com'),
STRUCT('Jhazel Camus','MAN','Tier 2','No','jhazel.camus@shopify.com'),
STRUCT('Joseph Jimenez','MAN','Tier 2','No','joseph.jimenez@shopify.com'),
STRUCT('Kevin Garcia','MAN','Tier 2','No','kevin.garcia@shopify.com'),
STRUCT('Marinelle Higante','MAN','Tier 2 - Audit','Yes','marinelle.higante@shopify.com'),
STRUCT('Mark Sibal','MAN','Tier 2','No','mark.sibal@shopify.com'),
STRUCT('Mary Esguerra','MAN','Tier 2','No','mary.esguerra@shopify.com'),
STRUCT('Nexus Baluran','MAN','Tier 1','No','nexus.baluran@shopify.com'),
STRUCT('Princes Severino','MAN','Tier 2','No','princes.severino@shopify.com'),
STRUCT('Rheyaleen Soriano','MAN','Tier 1','No','rheyaleen.soriano@shopify.com'),
STRUCT('Sheila Agaban','MAN','Tier 2','No','sheila.agaban@shopify.com'),
-- NOS Squad
STRUCT('Adriane Guzman','NOS','Tier 2','No','adriane.deguzman@shopify.com'),
STRUCT('Angel Fernandez','NOS','Tier 2','No','angel.fernandez@shopify.com'),
STRUCT('Bernard Alfonso','NOS','Tier 2','No','bernard.alfonso@shopify.com'),
STRUCT('Caryl Rivera','NOS','Tier 2','No','caryl.rivera@shopify.com'),
STRUCT('Ingmar Honawar','NOS','Tier 2','No','ingmar.honawar@shopify.com'),
STRUCT('Lawrence Lo','NOS','Tier 2','No','Lawrence.Lo@shopify.com'),
STRUCT('Nazareno Llenares','NOS','Tier 2','No','Nazareno.llenares@shopify.com'),
STRUCT('Prince Tajonera','NOS','Tier 2','No','prince.tajonera@shopify.com'),
STRUCT('Romel Obellano','NOS','Tier 2','No','romel.obellano@shopify.com'),
STRUCT('Ronnel Capunpue','NOS','Tier 2','No','ronnel.capunpue@shopify.com'),
STRUCT('Roselyn Santos','NOS','Tier 2','No','roselyn.santos@shopify.com'),
STRUCT('Samantha Sales','NOS','Tier 2','No','samantha.sales@shopify.com'),
STRUCT('Sean Terrence Abad','NOS','Tier 2','No','sean.abad@shopify.com'),
STRUCT('Veronica Musni','NOS','Tier 2','No','veronica.musni@shopify.com'),
-- KRM Squad
STRUCT('Alvin Alipio','KRM','Tier 2 - Audit','Yes','alvin.alipio@shopify.com'),
STRUCT('Andrew Exiomo','KRM','Tier 2 - Audit','Yes','andrewjames.exiomo@shopify.com'),
STRUCT('Bea Flores','KRM','Tier 2 - Audit','Yes','bea.flores@shopify.com'),
STRUCT('Christine Jhane Tolentino','KRM','Tier 2 - Audit','Yes','christine.tolentino@shopify.com'),
STRUCT('Cyrille Lacson Due','KRM','Tier 2 - Audit','Yes','cyrille.due@shopify.com'),
STRUCT('Dhang Losada','KRM','Tier 2 - Audit','Yes','dhang.losada@shopify.com'),
STRUCT('Ian Sanchez','KRM','Tier 2 - Audit','Yes','ian.sanchez@shopify.com'),
STRUCT('Jeremiah M','KRM','Tier 2 - Audit','Yes','jeremiah.mercado@shopify.com'),
STRUCT('Jid Dayrit','KRM','Tier 2 - Audit','Yes','jid.dayrit@shopify.com'),
STRUCT('Johanna Guzman','KRM','Tier 2 - Audit','Yes','johanna.deguzman@shopify.com'),
STRUCT('Jolina Romero','KRM','Tier 2 - Audit','Yes','jolina.romero@shopify.com'),
STRUCT('Justine Ignacio','KRM','Tier 2 - Audit','Yes','justine.ignacio@shopify.com'),
STRUCT('Kimberly Alzona','KRM','Tier 2 - Audit','Yes','kimberly.alzona@shopify.com'),
STRUCT('Mary Grace Ronquillo','KRM','Tier 2 - Audit','Yes','mary.ronquillo@shopify.com'),
STRUCT('Mimelanie Cunanan','KRM','Tier 2 - Audit','Yes','mimelanie.cunanan@shopify.com'),
STRUCT('Shaira Salgado','KRM','Tier 2 - Audit','Yes','shaira.salgado@shopify.com'),
-- RUE Squad
STRUCT('Diana Limiac','RUE','Tier 2','No','diana.limiac@shopify.com'),
STRUCT('Haidee Soto','RUE','Tier 2 - Audit','Yes','haidee.soto@shopify.com'),
STRUCT('Jainah David','RUE','Tier 2','No','jainah.david@shopify.com'),
STRUCT('Jenny-Lyn Lardizabal','RUE','Tier 2 - Audit','Yes','jenny-lyn.lardizabal@shopify.com'),
STRUCT('Juan Manio','RUE','Tier 2 - Audit','Yes','juan.manio@shopify.com'),
STRUCT('Kevin Alejo','RUE','Tier 2 - Audit','Yes','kevin.alejo@shopify.com'),
STRUCT('Lev Maghinang','RUE','Tier 2 - Audit','Yes','lev.maghinang@shopify.com'),
STRUCT('Louella Benedicto','RUE','Tier 2 - Audit','Yes','louella.benedicto@shopify.com'),
STRUCT('Maricar Manog','RUE','Tier 2 - Audit','Yes','maricar.manog@shopify.com'),
STRUCT('Marigold Ocampo','RUE','Tier 2 - Audit','Yes','marigold.ocampo@shopify.com'),
STRUCT('Marina Bacatan','RUE','Tier 2 - Audit','Yes','marina.bacatan@shopify.com'),
STRUCT('Mark Gopez','RUE','Tier 2 - Audit','Yes','mark.gopez@shopify.com'),
STRUCT('Mary Joyce Cubacub','RUE','Tier 2 - Audit','Yes','maryjoyce.cubacub@shopify.com'),
STRUCT('Rosell Feliciano','RUE','Tier 2 - Audit','Yes','rosell.feliciano@shopify.com'),
STRUCT('Yhana Valdez','RUE','Tier 2 - Audit','Yes','yhana.valdez@shopify.com'),
-- AE Squad
STRUCT('Adam Wishart', 'AE', 'Internal', 'No', 'adam.wishart@shopify.com'),
STRUCT('Adrian Anderson', 'AE', 'Internal', 'No', 'adrian.anderson@shopify.com'),
STRUCT('Alvin Li', 'AE', 'Internal', 'No', 'alvin.li@shopify.com'),
STRUCT('Devonne Harbin', 'AE', 'Internal', 'No', 'devonne.harbin@shopify.com'),
STRUCT('Keelan Filtness', 'AE', 'Internal', 'No', 'keelan.filtness@shopify.com'),
STRUCT('Khalaf Mohamed', 'AE', 'Internal', 'No', 'khalaf.mohamed@shopify.com'),
STRUCT('Shinya Kataoka', 'AE', 'Internal', 'No', 'shinya.kataoka@shopify.com'),
-- ESCY Squad
STRUCT('Pamela Gunawan', 'ESCY', 'Internal', 'No', 'pamela.gunawan@shopify.com'),
STRUCT('Said Montufar Maldonado', 'ESCY', 'Internal', 'No', 'said.montufarmaldonado@shopify.com'),
STRUCT('Sabrina Cui', 'ESCY', 'Internal', 'No', 'sabrina.cui@shopify.com'),
STRUCT('Max Arvidsson', 'ESCY', 'Internal', 'No', 'max.arvidsson@shopify.com'),
STRUCT('Blake Galley', 'ESCY', 'Internal', 'No', 'blake.galley@shopify.com'),
STRUCT('Kivon Mayers', 'ESCY', 'Internal', 'No', 'kivon.mayers@shopify.com'),
STRUCT('Dominic Stelmach', 'ESCY', 'Internal', 'No', 'dom.stelmach@shopify.com')
  ])
),

-- Raw assessment data aggregated to submission level
submission_summary AS (
  SELECT 
    app_store_app_submission_review_id,
    api_client_id,
    app_store_app_submission_id,
    is_first_submission_review,
    
    -- Use earliest assessment timestamp as submission time
    MIN(event_timestamp) AS submitted_at,
    
    -- Determine submission status based on assessments
    CASE 
      WHEN COUNT(CASE WHEN is_core_blocking_screening_criterion AND is_failed THEN 1 END) > 0 THEN 'REJECTED'
      WHEN COUNT(CASE WHEN assessment_was_valid_for_60_minutes AND assessment_result = 'PASSED' THEN 1 END) > 0 
       AND COUNT(CASE WHEN assessment_was_valid_for_60_minutes AND assessment_result = 'FAILED' THEN 1 END) = 0 THEN 'APPROVED'
      ELSE 'SUBMITTED'
    END AS submission_status,
    
    -- Get approval timestamp (latest passed assessment)
    MAX(CASE WHEN assessment_result = 'PASSED' THEN event_timestamp END) AS approved_at,
    
    -- Get primary reviewer (most frequent reviewer for this submission)
    APPROX_TOP_COUNT(reviewer_name, 1)[SAFE_OFFSET(0)].value AS primary_reviewer_name,
    
    -- Assessment counts for quality metrics
    COUNT(CASE WHEN assessment_was_valid_for_60_minutes THEN 1 END) AS valid_assessment_count,
    COUNT(CASE WHEN assessment_was_valid_for_60_minutes AND assessment_result = 'PASSED' THEN 1 END) AS passed_assessment_count,
    COUNT(CASE WHEN assessment_was_valid_for_60_minutes AND assessment_result = 'FAILED' THEN 1 END) AS failed_assessment_count
    
  FROM 
    `shopify-dw.apps_and_developers.app_store_app_submission_review_assessments_v1`
  WHERE 
    event_timestamp >= '2023-01-01'
    AND event_timestamp < '2027-01-01'  -- Include all of 2025 and 2026
    AND assessment_was_valid_for_60_minutes = TRUE  -- Only include valid assessments
  GROUP BY 
    app_store_app_submission_review_id,
    api_client_id,
    app_store_app_submission_id,
    is_first_submission_review
),

-- All actual data (including 2025 actuals when available)
actual_data AS (
  SELECT 
    submission_month,
    EXTRACT(YEAR FROM submission_month) AS year,
    EXTRACT(MONTH FROM submission_month) AS month,
    FORMAT_DATE('%B', submission_month) AS month_name,
    'Actual' AS data_type,
    
    -- Core metrics per your variable definitions
    COUNT(CASE WHEN ss.is_first_submission_review = TRUE THEN ss.app_store_app_submission_review_id END) AS app_submission_first,
    COUNT(CASE WHEN ss.is_first_submission_review = FALSE THEN ss.app_store_app_submission_review_id END) AS app_submission_re,
    COUNT(ss.app_store_app_submission_review_id) AS app_submission_total,
    COUNT(CASE WHEN ss.submission_status = 'APPROVED' THEN ss.app_store_app_submission_review_id END) AS app_publish,
    
    -- Headcount from reviewer metadata
    COUNT(DISTINCT CASE WHEN rm.reviewed_by IS NOT NULL AND rm.review_tier != 'Internal' THEN rm.reviewed_by END) AS headcount_taskus,
    COUNT(DISTINCT CASE WHEN rm.reviewed_by IS NOT NULL AND rm.review_tier = 'Internal' THEN rm.reviewed_by END) AS headcount_internal,
    COUNT(DISTINCT CASE WHEN rm.reviewed_by IS NOT NULL THEN rm.reviewed_by END) AS headcount_total,
    
    -- Time to publish calculation
    AVG(CASE WHEN ss.approved_at IS NOT NULL AND ss.submitted_at IS NOT NULL 
        THEN DATETIME_DIFF(ss.approved_at, ss.submitted_at, DAY) END) AS avg_time_to_publish_days,
    
    -- Quality metrics
    AVG(SAFE_DIVIDE(ss.passed_assessment_count, NULLIF(ss.valid_assessment_count, 0))) AS avg_pass_rate,
    SUM(ss.valid_assessment_count) AS total_assessments_performed
    
  FROM (
    SELECT 
      ss.*,
      DATE(DATE_TRUNC(ss.submitted_at, MONTH)) AS submission_month
    FROM submission_summary ss
  ) ss
  LEFT JOIN 
    reviewer_metadata rm ON ss.primary_reviewer_name = rm.reviewed_by
  GROUP BY 
    submission_month
),

-- Determine which months need forecasts (no actual data available)
months_needing_forecasts AS (
  SELECT 
    forecast_month
  FROM UNNEST([
    -- 2025 months
    DATE('2025-01-01'), DATE('2025-02-01'), DATE('2025-03-01'), DATE('2025-04-01'),
    DATE('2025-05-01'), DATE('2025-06-01'), DATE('2025-07-01'), DATE('2025-08-01'),
    DATE('2025-09-01'), DATE('2025-10-01'), DATE('2025-11-01'), DATE('2025-12-01'),
    -- 2026 months
    DATE('2026-01-01'), DATE('2026-02-01'), DATE('2026-03-01'), DATE('2026-04-01'),
    DATE('2026-05-01'), DATE('2026-06-01'), DATE('2026-07-01'), DATE('2026-08-01'),
    DATE('2026-09-01'), DATE('2026-10-01'), DATE('2026-11-01'), DATE('2026-12-01')
  ]) AS forecast_month
  WHERE forecast_month NOT IN (
    SELECT submission_month 
    FROM actual_data 
    WHERE EXTRACT(YEAR FROM submission_month) IN (2025, 2026)
  )
),

-- 2025-2026 Forecast data - only for months without actual data
forecast_data AS (
  SELECT 
    mnf.forecast_month AS submission_month,
    EXTRACT(YEAR FROM mnf.forecast_month) AS year,
    EXTRACT(MONTH FROM mnf.forecast_month) AS month,
    FORMAT_DATE('%B', mnf.forecast_month) AS month_name,
    'Forecast' AS data_type,
    
    fd.app_submission_first,
    fd.app_submission_re,
    fd.app_submission_total,
    fd.app_publish,
    
    -- Staffing plan (2025: 19/6/25, 2026: assuming slight growth)
    CASE 
      WHEN EXTRACT(YEAR FROM mnf.forecast_month) = 2025 THEN 19
      WHEN EXTRACT(YEAR FROM mnf.forecast_month) = 2026 THEN 20  -- Modest TaskUs growth
      ELSE 19
    END AS headcount_taskus,
    CASE 
      WHEN EXTRACT(YEAR FROM mnf.forecast_month) = 2025 THEN 6
      WHEN EXTRACT(YEAR FROM mnf.forecast_month) = 2026 THEN 7   -- Internal team growth
      ELSE 6
    END AS headcount_internal,
    CASE 
      WHEN EXTRACT(YEAR FROM mnf.forecast_month) = 2025 THEN 25
      WHEN EXTRACT(YEAR FROM mnf.forecast_month) = 2026 THEN 27  -- Total growth
      ELSE 25
    END AS headcount_total,
    
    CAST(NULL AS FLOAT64) AS avg_time_to_publish_days,
    CAST(NULL AS FLOAT64) AS avg_pass_rate,
    CAST(NULL AS INT64) AS total_assessments_performed

  FROM months_needing_forecasts mnf
  JOIN (
    SELECT * FROM UNNEST([
      -- 2025 Forecast Values
      STRUCT(DATE('2025-01-01') AS forecast_month, 495 AS app_submission_first, 99 AS app_submission_re, 594 AS app_submission_total, 495 AS app_publish),
      STRUCT(DATE('2025-02-01'), 577, 115, 692, 577),
      STRUCT(DATE('2025-03-01'), 591, 118, 709, 591),
      STRUCT(DATE('2025-04-01'), 500, 100, 600, 500),
      STRUCT(DATE('2025-05-01'), 517, 103, 620, 517),
      STRUCT(DATE('2025-06-01'), 521, 104, 625, 521),
      STRUCT(DATE('2025-07-01'), 637, 127, 764, 637),
      STRUCT(DATE('2025-08-01'), 691, 138, 829, 691),
      STRUCT(DATE('2025-09-01'), 725, 145, 870, 725),
      STRUCT(DATE('2025-10-01'), 632, 126, 758, 632),
      STRUCT(DATE('2025-11-01'), 738, 148, 886, 738),
      STRUCT(DATE('2025-12-01'), 497, 99, 596, 497),
      
      -- 2026 Forecast Values (7% growth over 2025 with seasonal patterns)
      STRUCT(DATE('2026-01-01'), 530, 106, 636, 530),  -- January +7%
      STRUCT(DATE('2026-02-01'), 617, 123, 740, 617),  -- February +7%
      STRUCT(DATE('2026-03-01'), 632, 126, 758, 632),  -- March +7%
      STRUCT(DATE('2026-04-01'), 535, 107, 642, 535),  -- April +7%
      STRUCT(DATE('2026-05-01'), 553, 111, 664, 553),  -- May +7%
      STRUCT(DATE('2026-06-01'), 557, 111, 668, 557),  -- June +7%
      STRUCT(DATE('2026-07-01'), 682, 136, 818, 682),  -- July +7%
      STRUCT(DATE('2026-08-01'), 739, 148, 887, 739),  -- August +7%
      STRUCT(DATE('2026-09-01'), 776, 155, 931, 776),  -- September +7%
      STRUCT(DATE('2026-10-01'), 676, 135, 811, 676),  -- October +7%
      STRUCT(DATE('2026-11-01'), 790, 158, 948, 790),  -- November +7%
      STRUCT(DATE('2026-12-01'), 532, 106, 638, 532)   -- December +7%
    ])
  ) fd ON mnf.forecast_month = fd.forecast_month
),

-- Combined data with calculated metrics
combined_data AS (
  SELECT 
    submission_month,
    year,
    month,
    month_name,
    data_type,
    app_submission_first,
    app_submission_re,
    app_submission_total,
    app_publish,
    headcount_taskus,
    headcount_internal,
    headcount_total,
    avg_time_to_publish_days,
    avg_pass_rate,
    total_assessments_performed,
    
    -- Productivity calculations
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_taskus, 0) AS FLOAT64)), 1) AS submissions_per_head_taskus,
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_total, 0) AS FLOAT64)), 1) AS submissions_per_head_total,
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_internal, 0) AS FLOAT64)), 1) AS submissions_per_head_internal,
    
    -- Assessment-based capacity metrics
    ROUND(SAFE_DIVIDE(CAST(total_assessments_performed AS FLOAT64), CAST(NULLIF(headcount_taskus, 0) AS FLOAT64)), 1) AS assessments_per_head_taskus,
    ROUND(SAFE_DIVIDE(CAST(total_assessments_performed AS FLOAT64), CAST(NULLIF(headcount_total, 0) AS FLOAT64)), 1) AS assessments_per_head_total,
    
    -- Traditional capacity metrics
    headcount_taskus * 45 AS taskus_monthly_screening_capacity,
    headcount_internal * 18 AS internal_monthly_screening_capacity,
    ROUND(app_submission_total * 1.7, 0) AS forecasted_screenings_per_submission
    
  FROM actual_data
  
  UNION ALL
  
  SELECT 
    submission_month,
    year,
    month,
    month_name,
    data_type,
    app_submission_first,
    app_submission_re,
    app_submission_total,
    app_publish,
    headcount_taskus,
    headcount_internal,
    headcount_total,
    avg_time_to_publish_days,
    avg_pass_rate,
    total_assessments_performed,
    
    -- Productivity calculations
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_taskus, 0) AS FLOAT64)), 1) AS submissions_per_head_taskus,
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_total, 0) AS FLOAT64)), 1) AS submissions_per_head_total,
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_internal, 0) AS FLOAT64)), 1) AS submissions_per_head_internal,
    
    -- Assessment-based capacity metrics (forecast placeholders)
    CAST(NULL AS FLOAT64) AS assessments_per_head_taskus,
    CAST(NULL AS FLOAT64) AS assessments_per_head_total,
    
    -- Traditional capacity metrics
    headcount_taskus * 45 AS taskus_monthly_screening_capacity,
    headcount_internal * 18 AS internal_monthly_screening_capacity,
    ROUND(app_submission_total * 1.7, 0) AS forecasted_screenings_per_submission
    
  FROM forecast_data
)

-- Final output with SLA targets and performance metrics
SELECT 
  submission_month,
  year,
  month,
  month_name,
  data_type,
  
  -- Core submission metrics
  app_submission_first,
  app_submission_re,
  app_submission_total,
  ROUND(SAFE_DIVIDE(CAST(app_submission_re AS FLOAT64), CAST(NULLIF(app_submission_first, 0) AS FLOAT64)) * 100, 1) AS resubmission_rate_pct,
  app_publish,
  ROUND(avg_time_to_publish_days, 1) AS avg_time_to_publish_days,
  
  -- Quality metrics from assessments
  ROUND(avg_pass_rate * 100, 1) AS assessment_pass_rate_pct,
  total_assessments_performed,
  
  -- Headcount metrics
  headcount_taskus,
  headcount_internal,
  headcount_total,
  
  -- Productivity metrics
  submissions_per_head_taskus,
  submissions_per_head_total,
  submissions_per_head_internal,
  
  -- Assessment-based productivity
  assessments_per_head_taskus,
  assessments_per_head_total,
  
  -- Capacity and screening metrics
  taskus_monthly_screening_capacity,
  internal_monthly_screening_capacity,
  forecasted_screenings_per_submission,
  
  -- SLA targets (constant values from your dashboard)
  760 AS taskus_hours_per_week_target,
  240 AS internal_hours_per_week_target,
  855 AS taskus_screenings_per_month_target,
  108 AS internal_screenings_per_month_target,
  90 AS quality_per_month_target,
  45 AS taskus_individual_monthly_screenings_target,
  90 AS taskus_individual_quality_score_target,
  18 AS internal_individual_monthly_screenings_target,
  
  -- Performance vs targets
  ROUND(SAFE_DIVIDE(CAST(taskus_monthly_screening_capacity AS FLOAT64), 855.0) * 100, 1) AS taskus_capacity_vs_target_pct,
  ROUND(SAFE_DIVIDE(CAST(internal_monthly_screening_capacity AS FLOAT64), 108.0) * 100, 1) AS internal_capacity_vs_target_pct,
  
  -- Workload analysis
  CASE 
    WHEN submissions_per_head_taskus > 24 THEN 'High'
    WHEN submissions_per_head_taskus > 20 THEN 'Medium' 
    ELSE 'Normal'
  END AS taskus_workload_level,
  
  CASE 
    WHEN submissions_per_head_internal > 35 THEN 'High'
    WHEN submissions_per_head_internal > 25 THEN 'Medium'
    ELSE 'Normal' 
  END AS internal_workload_level

FROM combined_data
ORDER BY submission_month;
