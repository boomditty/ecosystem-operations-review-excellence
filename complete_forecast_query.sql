-- Complete App Review Forecast Query
-- Combines historical data with 2025 forecasts to match your dashboard

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

-- Historical data from actual submissions
historical_data AS (
  SELECT 
    DATE_TRUNC(r.submitted_at, MONTH) AS submission_month,
    EXTRACT(YEAR FROM DATE_TRUNC(r.submitted_at, MONTH)) AS year,
    EXTRACT(MONTH FROM DATE_TRUNC(r.submitted_at, MONTH)) AS month,
    FORMAT_DATE('%B', DATE_TRUNC(r.submitted_at, MONTH)) AS month_name,
    'Actual' AS data_type,
    
    -- Core metrics per your variable definitions
    COUNT(CASE WHEN r.is_first_submission_review = TRUE AND r.latest_review_state = 'SUBMITTED' THEN r.app_store_app_submission_review_id END) AS app_submission_first,
    COUNT(CASE WHEN r.is_first_submission_review = FALSE AND r.latest_review_state = 'SUBMITTED' THEN r.app_store_app_submission_review_id END) AS app_submission_re,
    COUNT(CASE WHEN r.latest_review_state = 'SUBMITTED' THEN r.app_store_app_submission_review_id END) AS app_submission_total,
    COUNT(DISTINCT CASE WHEN r.latest_review_state = 'APPROVED' THEN r.app_store_app_submission_review_id END) AS app_publish,
    
    -- Headcount from reviewer metadata
    COUNT(DISTINCT CASE WHEN rm.reviewed_by IS NOT NULL AND rm.review_tier != 'Internal' THEN rm.reviewed_by END) AS headcount_taskus,
    COUNT(DISTINCT CASE WHEN rm.reviewed_by IS NOT NULL AND rm.review_tier = 'Internal' THEN rm.reviewed_by END) AS headcount_internal,
    COUNT(DISTINCT CASE WHEN rm.reviewed_by IS NOT NULL THEN rm.reviewed_by END) AS headcount_total,
    
    -- Time to publish
    AVG(CASE WHEN r.approved_at IS NOT NULL AND r.submitted_at IS NOT NULL THEN DATETIME_DIFF(r.approved_at, r.submitted_at, DAY) END) AS avg_time_to_publish_days
    
  FROM `shopify-dw.apps_and_developers.app_store_app_submission_reviews_v1` r
  LEFT JOIN reviewer_metadata rm ON COALESCE(r.reviewers[SAFE_OFFSET(0)].reviewer_name, '') = rm.reviewed_by
  WHERE DATE_TRUNC(r.submitted_at, MONTH) >= '2023-01-01'
    AND DATE_TRUNC(r.submitted_at, MONTH) < '2025-01-01'
  GROUP BY DATE_TRUNC(r.submitted_at, MONTH)
),

-- 2025 Forecast data based on your dashboard
forecast_data AS (
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
    
    -- 2025 staffing plan
    19 AS headcount_taskus,
    6 AS headcount_internal,
    25 AS headcount_total,
    
    NULL AS avg_time_to_publish_days

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
    
    -- Productivity calculations
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_taskus, 0) AS FLOAT64)), 1) AS submissions_per_head_taskus,
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_total, 0) AS FLOAT64)), 1) AS submissions_per_head_total,
    ROUND(SAFE_DIVIDE(CAST(app_submission_total AS FLOAT64), CAST(NULLIF(headcount_internal, 0) AS FLOAT64)), 1) AS submissions_per_head_internal,
    
    -- Capacity metrics
    headcount_taskus * 45 AS taskus_monthly_screening_capacity,
    headcount_internal * 18 AS internal_monthly_screening_capacity,
    ROUND(app_submission_total * 1.7, 0) AS forecasted_screenings_per_submission
    
  FROM historical_data
  
  UNION ALL
  
  SELECT * FROM forecast_data
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
  ROUND((app_submission_re / NULLIF(app_submission_first, 0)) * 100, 1) AS resubmission_rate_pct,
  app_publish,
  ROUND(avg_time_to_publish_days, 1) AS avg_time_to_publish_days,
  
  -- Headcount metrics
  headcount_taskus,
  headcount_internal,
  headcount_total,
  
  -- Productivity metrics
  submissions_per_head_taskus,
  submissions_per_head_total,
  submissions_per_head_internal,
  
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
