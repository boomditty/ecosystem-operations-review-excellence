# App Review Forecast Query - One-Page Overview

## 📊 **Purpose**
This BigQuery generates comprehensive monthly metrics for forecasting app review team operations, combining historical actuals (2023-2024) with 2025 forecasts to match your operational dashboard.

## 🏗️ **Query Structure**

### **Data Sources**
- **Primary Table**: `shopify-dw.apps_and_developers.app_store_app_submission_reviews_v1`
- **Reviewer Metadata**: Static CTE with 90+ reviewers across 7 squads (JFG, MAN, NOS, KRM, RUE, AE, ESCY)
- **2025 Forecasts**: Hardcoded monthly projections from your dashboard

### **Key CTEs**
1. **`reviewer_metadata`** - Maps reviewers to squads and tiers (TaskUs vs Internal)
2. **`raw_submissions`** - Filters base data (2023+ submissions)
3. **`historical_data`** - Aggregates actuals by month with reviewer joins
4. **`forecast_data`** - Static 2025 forecast values
5. **`combined_data`** - Merges historical + forecast with calculated metrics

---

## 🧮 **Core Metric Calculations**

### **Submission Metrics** (Your Variable Definitions)
- **`app_submission_first`** = COUNT(submissions WHERE `is_first_submission_review = TRUE` AND `latest_review_state = 'SUBMITTED'`)
- **`app_submission_re`** = COUNT(submissions WHERE `is_first_submission_review = FALSE` AND `latest_review_state = 'SUBMITTED'`)
- **`app_submission_total`** = `app_submission_first + app_submission_re`
- **`app_publish`** = COUNT(DISTINCT submissions WHERE `latest_review_state = 'APPROVED'`)
- **`resubmission_rate_pct`** = `(app_submission_re / app_submission_first) × 100`

### **Headcount Metrics**
- **`headcount_taskus`** = COUNT(DISTINCT reviewers WHERE `review_tier ≠ 'Internal'`)
- **`headcount_internal`** = COUNT(DISTINCT reviewers WHERE `review_tier = 'Internal'`)
- **`headcount_total`** = All unique reviewers
- **2025 Staffing Plan**: TaskUs = 19, Internal = 6, Total = 25

### **Productivity Metrics**
- **`submissions_per_head_taskus`** = `app_submission_total ÷ headcount_taskus`
- **`submissions_per_head_total`** = `app_submission_total ÷ headcount_total`
- **`submissions_per_head_internal`** = `app_submission_total ÷ headcount_internal`

### **Capacity Planning**
- **`taskus_monthly_screening_capacity`** = `headcount_taskus × 45 screenings/month`
- **`internal_monthly_screening_capacity`** = `headcount_internal × 18 screenings/month`
- **`forecasted_screenings_per_submission`** = `app_submission_total × 1.7`

### **Performance Tracking**
- **`avg_time_to_publish_days`** = AVG(`DATETIME_DIFF(approved_at, submitted_at, DAY)`)
- **`taskus_capacity_vs_target_pct`** = `(taskus_capacity ÷ 855) × 100`
- **`internal_capacity_vs_target_pct`** = `(internal_capacity ÷ 108) × 100`

---

## 🎯 **SLA Targets** (From Dashboard)

| Metric | TaskUs Target | Internal Target |
|--------|---------------|-----------------|
| **Hours/Week** | 760 | 240 |
| **Screenings/Month** | 855 | 108 |
| **Individual Screenings** | 45/month | 18/month |
| **Quality Score** | 90 | - |

---

## 📈 **2025 Forecast Integration**

**Monthly Projections**: 495-738 first submissions (Jan-Nov 2025)
**Peak Months**: September (725), November (738)
**Capacity Planning**: Based on 19 TaskUs + 6 Internal reviewers

### **Workload Analysis**
- **High**: >24 submissions/head (TaskUs), >35 (Internal)
- **Medium**: 20-24 (TaskUs), 25-35 (Internal)
- **Normal**: <20 (TaskUs), <25 (Internal)

---

## 🔧 **Key Technical Features**

### **BigQuery Compatibility**
- ✅ Fixed GROUP BY aggregation issues
- ✅ Resolved UNION ALL type mismatches (TIMESTAMP→DATE)
- ✅ Standard SQL syntax throughout

### **Data Quality**
- **Reviewer Assignment**: Uses first reviewer in `reviewers` array
- **Date Handling**: Monthly aggregation via `DATE_TRUNC()`
- **Null Safety**: `SAFE_DIVIDE()` prevents division by zero

### **Assumptions**
- **Screening Ratio**: 1.7 screenings per submission
- **Capacity Model**: TaskUs=45, Internal=18 monthly screenings
- **Resubmission Rate**: ~20% of first submissions

---

## 🚀 **Usage**

**Query Output**: Monthly time series from 2023-2025 with:
- Historical actuals (`data_type = 'Actual'`)
- 2025 forecasts (`data_type = 'Forecast'`)
- All dashboard metrics calculated
- Performance vs SLA targets
- Workload level indicators

**Business Value**: Complete operational forecasting dataset for capacity planning, performance tracking, and resource allocation decisions.

---

*Query file: `complete_forecast_query_fixed.sql` | Ready for production use*
