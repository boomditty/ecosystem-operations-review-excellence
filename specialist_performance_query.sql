-- Specialist Performance Management Query
-- Individual reviewer analytics and performance tracking
-- Based on app_store_app_submission_review_assessments_v1

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

-- Individual specialist performance metrics
specialist_performance AS (
  SELECT 
    a.reviewer_name,
    rm.squad_code,
    rm.review_tier,
    DATE_TRUNC(a.event_timestamp, MONTH) AS performance_month,
    
    -- Volume metrics
    COUNT(CASE WHEN a.assessment_was_valid_for_60_minutes THEN 1 END) AS total_assessments,
    COUNT(DISTINCT a.app_store_app_submission_review_id) AS unique_submissions_worked,
    COUNT(DISTINCT DATE(a.event_timestamp)) AS active_days,
    
    -- Quality metrics
    COUNT(CASE WHEN a.assessment_was_valid_for_60_minutes AND a.assessment_result = 'PASSED' THEN 1 END) AS passed_assessments,
    COUNT(CASE WHEN a.assessment_was_valid_for_60_minutes AND a.assessment_result = 'FAILED' THEN 1 END) AS failed_assessments,
    
    -- Complexity metrics
    COUNT(CASE WHEN a.is_core_blocking_screening_criterion THEN 1 END) AS core_blocking_assessments,
    COUNT(CASE WHEN a.screening_criterion_severity = 'HIGH' THEN 1 END) AS high_severity_assessments,
    
    -- First-time vs re-review metrics
    COUNT(CASE WHEN a.is_first_submission_review THEN 1 END) AS first_submission_assessments,
    COUNT(CASE WHEN NOT a.is_first_submission_review THEN 1 END) AS resubmission_assessments,
    
    -- Automated check interaction
    COUNT(CASE WHEN a.has_automated_check THEN 1 END) AS assessments_with_automation,
    COUNT(CASE WHEN a.is_automated_check_true_positive THEN 1 END) AS automation_agreements,
    COUNT(CASE WHEN a.is_automated_check_false_negative THEN 1 END) AS missed_by_automation,
    COUNT(CASE WHEN a.is_automated_check_false_positive THEN 1 END) AS automation_overcatch
    
  FROM 
    `shopify-dw.apps_and_developers.app_store_app_submission_review_assessments_v1` a
  LEFT JOIN 
    reviewer_metadata rm ON a.reviewer_name = rm.reviewed_by
  WHERE 
    a.event_timestamp >= '2023-01-01'
    AND a.event_timestamp < '2027-01-01'
    AND a.assessment_was_valid_for_60_minutes = TRUE
    AND a.reviewer_name IS NOT NULL
  GROUP BY 
    a.reviewer_name,
    rm.squad_code,
    rm.review_tier,
    DATE_TRUNC(a.event_timestamp, MONTH)
),

-- Calculate performance metrics and rankings
specialist_metrics AS (
  SELECT 
    *,
    
    -- Productivity calculations
    ROUND(SAFE_DIVIDE(total_assessments, NULLIF(active_days, 0)), 1) AS assessments_per_active_day,
    ROUND(SAFE_DIVIDE(unique_submissions_worked, NULLIF(active_days, 0)), 1) AS submissions_per_active_day,
    
    -- Quality calculations
    ROUND(SAFE_DIVIDE(passed_assessments, NULLIF(total_assessments, 0)) * 100, 1) AS pass_rate_pct,
    ROUND(SAFE_DIVIDE(failed_assessments, NULLIF(total_assessments, 0)) * 100, 1) AS fail_rate_pct,
    
    -- Specialization indicators
    ROUND(SAFE_DIVIDE(core_blocking_assessments, NULLIF(total_assessments, 0)) * 100, 1) AS core_blocking_pct,
    ROUND(SAFE_DIVIDE(first_submission_assessments, NULLIF(total_assessments, 0)) * 100, 1) AS new_app_focus_pct,
    
    -- Automation interaction
    ROUND(SAFE_DIVIDE(automation_agreements, NULLIF(assessments_with_automation, 0)) * 100, 1) AS automation_agreement_pct,
    ROUND(SAFE_DIVIDE(missed_by_automation, NULLIF(assessments_with_automation, 0)) * 100, 1) AS human_catch_rate_pct,
    
    -- Performance rankings within month and tier
    ROW_NUMBER() OVER (
      PARTITION BY performance_month, review_tier 
      ORDER BY total_assessments DESC
    ) AS volume_rank,
    ROW_NUMBER() OVER (
      PARTITION BY performance_month, review_tier 
      ORDER BY SAFE_DIVIDE(passed_assessments, NULLIF(total_assessments, 0)) DESC
    ) AS quality_rank,
    ROW_NUMBER() OVER (
      PARTITION BY performance_month, review_tier 
      ORDER BY SAFE_DIVIDE(total_assessments, NULLIF(active_days, 0)) DESC
    ) AS efficiency_rank
    
  FROM specialist_performance
  WHERE total_assessments >= 10  -- Minimum threshold for meaningful analysis
),

-- Specialist performance summary with peer comparisons
specialist_summary AS (
  SELECT 
    reviewer_name,
    squad_code,
    review_tier,
    performance_month,
    
    -- Core metrics
    total_assessments,
    unique_submissions_worked,
    active_days,
    assessments_per_active_day,
    submissions_per_active_day,
    pass_rate_pct,
    
    -- Specialization
    core_blocking_pct,
    new_app_focus_pct,
    automation_agreement_pct,
    human_catch_rate_pct,
    
    -- Rankings
    volume_rank,
    quality_rank,
    efficiency_rank,
    
    -- Performance vs peers (same tier)
    total_assessments - AVG(total_assessments) OVER (
      PARTITION BY performance_month, review_tier
    ) AS assessments_vs_tier_avg,
    
    pass_rate_pct - AVG(pass_rate_pct) OVER (
      PARTITION BY performance_month, review_tier
    ) AS quality_vs_tier_avg,
    
    assessments_per_active_day - AVG(assessments_per_active_day) OVER (
      PARTITION BY performance_month, review_tier
    ) AS efficiency_vs_tier_avg,
    
    -- Performance categories
    CASE 
      WHEN volume_rank <= 3 AND quality_rank <= 5 THEN 'Top Performer'
      WHEN volume_rank <= 5 AND quality_rank <= 10 THEN 'Strong Performer'  
      WHEN pass_rate_pct < 85 OR efficiency_rank > (COUNT(*) OVER (PARTITION BY performance_month, review_tier) * 0.8) THEN 'Needs Support'
      ELSE 'Solid Performer'
    END AS performance_category,
    
    -- Improvement opportunities
    CASE 
      WHEN pass_rate_pct < 90 THEN 'Quality Training'
      WHEN assessments_per_active_day < 15 THEN 'Productivity Coaching'
      WHEN automation_agreement_pct < 80 THEN 'Automation Alignment'
      WHEN human_catch_rate_pct > 20 THEN 'Advanced Training'
      ELSE 'Maintain Excellence'
    END AS development_focus
    
  FROM specialist_metrics
)

-- Final output: Specialist performance dashboard
SELECT 
  performance_month,
  EXTRACT(YEAR FROM performance_month) AS year,
  EXTRACT(MONTH FROM performance_month) AS month,
  FORMAT_DATE('%B %Y', performance_month) AS month_name,
  
  -- Specialist identity
  reviewer_name,
  squad_code,
  review_tier,
  
  -- Core performance metrics
  total_assessments,
  unique_submissions_worked,
  active_days,
  ROUND(assessments_per_active_day, 1) AS assessments_per_active_day,
  ROUND(submissions_per_active_day, 1) AS submissions_per_active_day,
  
  -- Quality metrics
  ROUND(pass_rate_pct, 1) AS pass_rate_pct,
  ROUND(core_blocking_pct, 1) AS core_blocking_pct,
  ROUND(new_app_focus_pct, 1) AS new_app_focus_pct,
  
  -- Automation interaction
  ROUND(automation_agreement_pct, 1) AS automation_agreement_pct,
  ROUND(human_catch_rate_pct, 1) AS human_catch_rate_pct,
  
  -- Performance rankings
  volume_rank,
  quality_rank, 
  efficiency_rank,
  
  -- Peer comparisons
  ROUND(assessments_vs_tier_avg, 1) AS assessments_vs_peer_avg,
  ROUND(quality_vs_tier_avg, 1) AS quality_vs_peer_avg,
  ROUND(efficiency_vs_tier_avg, 1) AS efficiency_vs_peer_avg,
  
  -- Performance insights
  performance_category,
  development_focus,
  
  -- Workload indicators
  CASE 
    WHEN assessments_per_active_day > 25 THEN 'High Workload'
    WHEN assessments_per_active_day > 20 THEN 'Medium Workload'
    ELSE 'Normal Workload'
  END AS workload_level,
  
  -- Quality indicators  
  CASE 
    WHEN pass_rate_pct >= 95 THEN 'Excellent Quality'
    WHEN pass_rate_pct >= 90 THEN 'Good Quality'
    WHEN pass_rate_pct >= 85 THEN 'Acceptable Quality'
    ELSE 'Needs Improvement'
  END AS quality_level

FROM specialist_summary
WHERE performance_month >= DATE_SUB(CURRENT_DATE(), INTERVAL 6 MONTH)  -- Last 6 months
ORDER BY 
  performance_month DESC,
  review_tier,
  total_assessments DESC;

