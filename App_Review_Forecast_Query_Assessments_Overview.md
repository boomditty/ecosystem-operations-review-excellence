# App Review Forecast Query (Assessments Version) - One-Page Overview

## 📊 **Purpose**
This BigQuery generates comprehensive monthly metrics for forecasting app review team operations using **assessment-level data** for maximum accuracy. Dynamically combines actual data (including 2025) with forecasts only for future months.

## 🏗️ **Query Architecture**

### **Data Sources**
- **Primary Table**: `shopify-dw.apps_and_developers.app_store_app_submission_review_assessments_v1`
- **Granularity**: Assessment-level (1 row = 1 screening criterion assessment)
- **Reviewer Metadata**: Static CTE with 90+ reviewers across 7 squads
- **2025 Forecasts**: Dynamic - only for months without actual data

### **Key CTEs Flow**
1. **`submission_summary`** - Aggregates assessments → submission level
2. **`actual_data`** - Monthly aggregation with reviewer joins (2023-2025+)
3. **`months_needing_forecasts`** - Identifies 2025 months without actual data
4. **`forecast_data`** - Static forecasts only for missing months
5. **`combined_data`** - Merges actual + forecast with calculations

---

## 🧮 **Core Field Mappings & Calculations**

### **Assessment → Submission Aggregation**
| Submission Field | Assessment-Based Logic |
|------------------|------------------------|
| **`submitted_at`** | `MIN(event_timestamp)` - earliest assessment |
| **`submission_status`** | Smart derivation from screening criteria results |
| **`approved_at`** | `MAX(event_timestamp WHERE assessment_result = 'PASSED')` |
| **`primary_reviewer_name`** | `APPROX_TOP_COUNT(reviewer_name, 1)` - most frequent |

### **Status Determination Logic**
```sql
CASE 
  WHEN COUNT(core_blocking_failures) > 0 THEN 'REJECTED'
  WHEN COUNT(passed_assessments) > 0 AND COUNT(failed_assessments) = 0 THEN 'APPROVED' 
  ELSE 'SUBMITTED'
END
```

### **Core Submission Metrics**
- **`app_submission_first`** = COUNT(submissions WHERE `is_first_submission_review = TRUE`)
- **`app_submission_re`** = COUNT(submissions WHERE `is_first_submission_review = FALSE`)  
- **`app_submission_total`** = `app_submission_first + app_submission_re`
- **`app_publish`** = COUNT(submissions WHERE `submission_status = 'APPROVED'`)
- **`resubmission_rate_pct`** = `(app_submission_re ÷ app_submission_first) × 100`

### **Headcount Metrics**
- **`headcount_taskus`** = COUNT(DISTINCT reviewers WHERE `review_tier ≠ 'Internal'`)
- **`headcount_internal`** = COUNT(DISTINCT reviewers WHERE `review_tier = 'Internal'`)
- **`headcount_total`** = All unique reviewers
- **2025 Staffing Plan**: TaskUs = 19, Internal = 6, Total = 25

---

## 📈 **Enhanced Quality Metrics** (New!)

### **Assessment-Level Analytics**
- **`assessment_pass_rate_pct`** = `(passed_assessments ÷ total_valid_assessments) × 100`
- **`total_assessments_performed`** = COUNT(valid assessments with 60min rule)
- **`assessments_per_head_taskus`** = `total_assessments ÷ headcount_taskus`
- **`assessments_per_head_total`** = `total_assessments ÷ headcount_total`

### **Data Quality Controls**
- **Valid Assessment Filter**: `assessment_was_valid_for_60_minutes = TRUE`
- **Purpose**: Eliminates misclicks and automatically saved results
- **Impact**: Only counts assessments that remained stable for 60+ minutes

---

## 🎯 **Productivity & Capacity Calculations**

### **Submission-Based Productivity**
- **`submissions_per_head_taskus`** = `app_submission_total ÷ headcount_taskus`
- **`submissions_per_head_total`** = `app_submission_total ÷ headcount_total`  
- **`submissions_per_head_internal`** = `app_submission_total ÷ headcount_internal`

### **Assessment-Based Productivity** (New!)
- **`assessments_per_head_taskus`** = More granular workload tracking
- **`assessments_per_head_total`** = Total team assessment productivity

### **Capacity Planning**
- **`taskus_monthly_screening_capacity`** = `headcount_taskus × 45`
- **`internal_monthly_screening_capacity`** = `headcount_internal × 18`
- **`forecasted_screenings_per_submission`** = `app_submission_total × 1.7`

### **Performance Tracking**
- **`avg_time_to_publish_days`** = AVG(`DATETIME_DIFF(approved_at, submitted_at, DAY)`)
- **`taskus_capacity_vs_target_pct`** = `(taskus_capacity ÷ 855) × 100`
- **`internal_capacity_vs_target_pct`** = `(internal_capacity ÷ 108) × 100`

---

## 🔄 **Dynamic Actual vs Forecast Logic** (Updated!)

### **Smart Data Type Assignment**
- **`data_type = 'Actual'`**: All months with real assessment data (including 2025)
- **`data_type = 'Forecast'`**: Only 2025 months without actual data

### **Forecast Selection Logic**
```sql
months_needing_forecasts AS (
  SELECT forecast_month FROM [all_2025_months]
  WHERE forecast_month NOT IN (
    SELECT submission_month FROM actual_data WHERE year = 2025
  )
)
```

### **Business Impact**
- **January 2025**: Shows 'Actual' if you have real assessment data
- **Future months**: Shows 'Forecast' until actual data becomes available
- **Automatically adapts** as 2025 progresses

---

## 🎯 **SLA Targets & Benchmarks**

| Metric | TaskUs Target | Internal Target |
|--------|---------------|-----------------|
| **Hours/Week** | 760 | 240 |
| **Screenings/Month** | 855 | 108 |
| **Individual Screenings** | 45/month | 18/month |
| **Quality Score** | 90 | - |

### **Workload Analysis Thresholds**
- **TaskUs**: High >24, Medium 20-24, Normal <20 submissions/head
- **Internal**: High >35, Medium 25-35, Normal <25 submissions/head

---

## 🔧 **Technical Features**

### **Assessment Aggregation**
- **Quality Focus**: Uses `assessment_was_valid_for_60_minutes = TRUE`
- **Reviewer Attribution**: Most frequent reviewer per submission
- **Status Accuracy**: Derived from actual screening criteria results
- **Time Range**: 2023-2026 (includes all of 2025)

### **BigQuery Optimizations**
- ✅ Proper GROUP BY expressions for all non-aggregated fields
- ✅ Type-consistent UNION ALL (all DATE types)
- ✅ `SAFE_DIVIDE()` prevents division by zero errors
- ✅ Efficient CTE structure for performance

### **Business Assumptions**
- **Assessment Validity**: 60-minute rule eliminates reviewer errors
- **Primary Reviewer**: Most active reviewer represents the submission
- **Approval Logic**: All criteria passed AND no blocking failures
- **Capacity Model**: Traditional 45/18 monthly screening targets

---

## 🚀 **Query Output**

**Result Set**: Monthly time series with:
- **Actual data**: Real assessment-based metrics (2023-2025+)
- **Forecast data**: Projected values only for future months
- **40+ calculated fields**: All dashboard metrics + enhanced quality analytics
- **Assessment insights**: Pass rates, reviewer productivity, quality trends

**Business Value**: Most accurate operational forecasting dataset with granular quality insights for data-driven capacity planning and performance optimization.

---

*Query file: `complete_forecast_query_assessments.sql` | Assessment-level accuracy | Dynamic actual/forecast logic*

