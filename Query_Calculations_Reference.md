# Query Calculations Reference - Assessment-Based Forecast Query

## 🔄 **Assessment → Submission Aggregation**

### **Submission Timing**
- **`submitted_at`** = `MIN(event_timestamp)` - Uses earliest assessment as submission time
- **`approved_at`** = `MAX(event_timestamp WHERE assessment_result = 'PASSED')` - Latest passing assessment

### **Submission Status Logic**
```sql
submission_status = CASE 
  WHEN COUNT(core_blocking_failures) > 0 THEN 'REJECTED'
  WHEN COUNT(passed_assessments) > 0 AND COUNT(failed_assessments) = 0 THEN 'APPROVED'
  ELSE 'SUBMITTED'
END
```
- **REJECTED**: Any core blocking screening criterion failed
- **APPROVED**: All assessments passed, no failures
- **SUBMITTED**: Default state (in progress or mixed results)

### **Reviewer Attribution**
- **`primary_reviewer_name`** = `APPROX_TOP_COUNT(reviewer_name, 1)` - Most frequent reviewer per submission

---

## 📊 **Core Submission Metrics**

### **Submission Counts**
- **`app_submission_first`** = `COUNT(WHERE is_first_submission_review = TRUE)` - New app submissions
- **`app_submission_re`** = `COUNT(WHERE is_first_submission_review = FALSE)` - Resubmissions  
- **`app_submission_total`** = `app_submission_first + app_submission_re` - All submissions
- **`app_publish`** = `COUNT(WHERE submission_status = 'APPROVED')` - Successfully approved apps

### **Performance Ratios**
- **`resubmission_rate_pct`** = `(app_submission_re ÷ app_submission_first) × 100` - Resubmission percentage
- **`avg_time_to_publish_days`** = `AVG(DATETIME_DIFF(approved_at, submitted_at, DAY))` - Average approval time

---

## 👥 **Headcount Calculations**

### **Team Segmentation**
- **`headcount_taskus`** = `COUNT(DISTINCT reviewer WHERE review_tier ≠ 'Internal')` - External reviewers
- **`headcount_internal`** = `COUNT(DISTINCT reviewer WHERE review_tier = 'Internal')` - Shopify employees  
- **`headcount_total`** = `COUNT(DISTINCT reviewer)` - All reviewers combined

### **Staffing Plan** (Dynamic by Year)
- **2025**: TaskUs=19, Internal=6, Total=25
- **2026**: TaskUs=20, Internal=7, Total=27 (growth assumptions)

---

## ✅ **Quality & Assessment Metrics**

### **Assessment Quality**
- **`valid_assessment_count`** = `COUNT(WHERE assessment_was_valid_for_60_minutes = TRUE)` - Stable assessments only
- **`passed_assessment_count`** = `COUNT(WHERE assessment_result = 'PASSED' AND valid)` - Successful assessments
- **`failed_assessment_count`** = `COUNT(WHERE assessment_result = 'FAILED' AND valid)` - Failed assessments

### **Quality Rates**
- **`avg_pass_rate`** = `passed_assessments ÷ total_valid_assessments` - Assessment success rate
- **`assessment_pass_rate_pct`** = `avg_pass_rate × 100` - Percentage format
- **`total_assessments_performed`** = `SUM(valid_assessment_count)` - Monthly assessment volume

---

## 📈 **Productivity Calculations**

### **Submission-Based Productivity**
- **`submissions_per_head_taskus`** = `app_submission_total ÷ headcount_taskus` - TaskUs reviewer load
- **`submissions_per_head_total`** = `app_submission_total ÷ headcount_total` - Overall team productivity
- **`submissions_per_head_internal`** = `app_submission_total ÷ headcount_internal` - Internal team load

### **Assessment-Based Productivity** (New!)
- **`assessments_per_head_taskus`** = `total_assessments ÷ headcount_taskus` - TaskUs assessment workload
- **`assessments_per_head_total`** = `total_assessments ÷ headcount_total` - Team assessment productivity

---

## 🎯 **Capacity Planning**

### **Monthly Screening Capacity**
- **`taskus_monthly_screening_capacity`** = `headcount_taskus × 45` - TaskUs target screenings/month
- **`internal_monthly_screening_capacity`** = `headcount_internal × 18` - Internal target screenings/month
- **`forecasted_screenings_per_submission`** = `app_submission_total × 1.7` - Expected screening volume

### **SLA Performance vs Targets**
- **`taskus_capacity_vs_target_pct`** = `(taskus_capacity ÷ 855) × 100` - TaskUs capacity utilization
- **`internal_capacity_vs_target_pct`** = `(internal_capacity ÷ 108) × 100` - Internal capacity utilization

---

## 📊 **Workload Analysis**

### **TaskUs Workload Levels**
```sql
taskus_workload_level = CASE 
  WHEN submissions_per_head_taskus > 24 THEN 'High'
  WHEN submissions_per_head_taskus > 20 THEN 'Medium'
  ELSE 'Normal'
END
```

### **Internal Workload Levels**
```sql
internal_workload_level = CASE 
  WHEN submissions_per_head_internal > 35 THEN 'High' 
  WHEN submissions_per_head_internal > 25 THEN 'Medium'
  ELSE 'Normal'
END
```

---

## 🔮 **Forecast Logic**

### **Dynamic Actual vs Forecast**
```sql
months_needing_forecasts = [all_2025_2026_months] 
WHERE month NOT IN (SELECT month FROM actual_data)
```
- **Uses actual data** when available from assessments table
- **Uses forecast values** only for months without real data

### **2026 Forecast Values**
- **Growth Model**: 7% year-over-year growth applied to 2025 baseline
- **Seasonal Patterns**: Maintains monthly seasonality (peak Sep/Nov)
- **Example**: 2025 Jan=495 → 2026 Jan=530 (+7%)

### **Forecast Assumptions**
- **Resubmission Rate**: ~20% of first submissions
- **Approval Rate**: Matches first submission count (optimistic)
- **Team Growth**: Modest expansion (TaskUs +1, Internal +1)

---

## 🎯 **Key Business Constants**

### **SLA Targets**
- TaskUs: 760 hrs/week, 855 screenings/month, 45 individual/month, 90 quality
- Internal: 240 hrs/week, 108 screenings/month, 18 individual/month

### **Operational Assumptions** 
- **Assessment Validity**: 60-minute rule eliminates reviewer errors
- **Screening Ratio**: 1.7 screenings per submission average
- **Primary Reviewer**: Most active reviewer represents the submission

---

*Each calculation is designed for accuracy, using assessment-level data to provide the most precise operational forecasting possible.*

