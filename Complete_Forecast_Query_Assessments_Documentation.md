# Complete Forecast Query with Assessments - Technical Documentation

## Overview

This query combines historical app review data with forecasted projections through 2026, providing comprehensive metrics on team performance, capacity utilization, and screening output. It integrates data from two primary sources to track both assessment-based quality metrics and actual screening activities performed by reviewers.

**Time Range:** January 2023 - December 2026 (48 months)  
**Data Types:** Actual (historical) + Forecast (future projections)

---

## Data Sources

### 1. `app_store_app_submission_review_assessments_v1`
- **Purpose:** Tracks individual assessment events on screening criteria
- **Key Fields:**
  - `event_timestamp` - When the assessment occurred
  - `assessment_result` - PASSED or FAILED
  - `assessment_was_valid_for_60_minutes` - Quality filter
  - `is_core_blocking_screening_criterion` - Critical failures
  - `reviewer_name` - Who performed the assessment

### 2. `app_store_app_submission_reviews_v1`
- **Purpose:** Tracks reviewer activity and submission lifecycle
- **Key Fields:**
  - `reviewers` - Array of reviewers with review dates and time spent
  - `latest_review_state` - Current state (APPROVED, REJECTED, SUBMITTED, WITHDRAWN)
  - `app_store_app_submission_review_id` - Unique submission identifier
  - **Note:** Uses UNNEST to extract individual reviewer activity from the array

---

## Query Structure (CTEs)

### 1. **reviewer_metadata**
Hard-coded roster of all reviewers with classifications:
- **Squad Codes:** JFG, MAN, NOS, KRM, RUE (TaskUs), AE, ESCY (Internal)
- **Review Tier:** Tier 1, Tier 2, Tier 2 - Audit, Internal
- **Purpose:** Categorizes reviewers as TaskUs vs Internal for all calculations

### 2. **app_screenings**
```sql
UNNEST(r.reviewers) AS reviewer
```
Extracts individual reviewer activity from the reviewers array in the reviews table.

**Calculation:**
- Counts distinct `app_store_app_submission_review_id` per reviewer per month
- Filters out 'SUBMITTED' and 'WITHDRAWN' states (no actual work performed)
- Groups by `reviewer.review_date` and `reviewer.reviewer_name`

**Result:** Monthly screening count per individual reviewer

### 3. **monthly_screenings**
Aggregates `app_screenings` by reviewer type.

**Calculations:**
- `taskus_screenings` = SUM(screenings WHERE review_tier != 'Internal')
- `internal_screenings` = SUM(screenings WHERE review_tier = 'Internal')
- `total_screenings` = SUM(all screenings)

**Result:** Total monthly screening output by team type

### 4. **submission_summary**
Aggregates assessment events to the submission level.

**Key Calculations:**

**Submission Status Logic:**
```sql
CASE 
  WHEN core_blocking_failure > 0 THEN 'REJECTED'
  WHEN all_valid_passed AND no_valid_failures THEN 'APPROVED'
  ELSE 'SUBMITTED'
END
```

**Quality Metrics Per Submission:**
- `valid_assessment_count` - Total valid assessments (60-min validity window)
- `passed_assessment_count` - Assessments with PASSED result
- `failed_assessment_count` - Assessments with FAILED result
- `pass_rate` = passed / valid (calculated per submission)

**Timestamps:**
- `submitted_at` = MIN(event_timestamp) - Earliest assessment
- `approved_at` = MAX(event_timestamp WHERE result = 'PASSED') - Latest approval

### 5. **actual_data**
Aggregates submission_summary and monthly_screenings to monthly level.

**Core Submission Metrics:**
- `app_submission_first` = COUNT(WHERE is_first_submission_review = TRUE)
- `app_submission_re` = COUNT(WHERE is_first_submission_review = FALSE)
- `app_submission_total` = COUNT(all submissions)
- `app_publish` = COUNT(WHERE submission_status = 'APPROVED')

**Headcount Calculations:**
Uses DISTINCT COUNT on reviewers joined with reviewer_metadata:
- `headcount_taskus` = COUNT(DISTINCT reviewer WHERE review_tier != 'Internal')
- `headcount_internal` = COUNT(DISTINCT reviewer WHERE review_tier = 'Internal')
- `headcount_total` = COUNT(DISTINCT all reviewers)

**Time to Publish:**
```sql
AVG(DATETIME_DIFF(approved_at, submitted_at, DAY))
```
Only calculated for approved submissions with both timestamps.

**Quality Metrics:**
- `avg_pass_rate` = AVG(passed_assessment_count / valid_assessment_count) across all submissions
- `total_assessments_performed` = SUM(valid_assessment_count) for the month

**App Screening Actuals:**
- `taskus_actual_screenings` - From monthly_screenings CTE
- `internal_actual_screenings` - From monthly_screenings CTE
- `total_actual_screenings` - From monthly_screenings CTE

### 6. **months_needing_forecasts**
Identifies months in 2025-2026 without actual data.

**Logic:** Checks which forecast months are NOT present in actual_data for those years.

### 7. **forecast_data**
Provides forecasted values for months without actuals.

**Forecasted Headcount:**
- 2025: 19 TaskUs / 6 Internal / 25 Total
- 2026: 20 TaskUs / 7 Internal / 27 Total

**Forecasted Submissions:**
- Based on historical trends with 7% YoY growth for 2026
- Seasonal patterns maintained (higher in summer months)
- Resubmission rate: ~20% (99 re / 495 first)

**NULL Fields:**
- Quality metrics (pass rates, assessments)
- Time to publish
- Actual screening counts (can't forecast individual performance)

### 8. **combined_data**
Merges actual and forecast data with calculated productivity metrics.

**Productivity Calculations:**

**Submissions Per Head:**
```sql
submissions_per_head_taskus = app_submission_total / headcount_taskus
submissions_per_head_total = app_submission_total / headcount_total
submissions_per_head_internal = app_submission_total / headcount_internal
```

**Assessments Per Head:**
```sql
assessments_per_head_taskus = total_assessments_performed / headcount_taskus
assessments_per_head_total = total_assessments_performed / headcount_total
```

**App Screening Productivity (NEW):**
```sql
taskus_screenings_per_fte = taskus_actual_screenings / headcount_taskus
internal_screenings_per_fte = internal_actual_screenings / headcount_internal
```
This measures actual screening output per FTE against the 45/month target.

**Capacity Metrics:**
```sql
taskus_monthly_screening_capacity = headcount_taskus * 45
internal_monthly_screening_capacity = headcount_internal * 18
forecasted_screenings_per_submission = app_submission_total * 1.7
```

### 9. **Final SELECT**
Combines all metrics with performance indicators and targets.

---

## Key Calculations Explained

### 1. Resubmission Rate
```sql
resubmission_rate_pct = (app_submission_re / app_submission_first) * 100
```
**Interpretation:** Higher values indicate more rejections requiring resubmissions.  
**Example:** 195.8% means nearly 2 resubmissions per first submission.

### 2. Assessment Pass Rate
```sql
assessment_pass_rate_pct = (avg_pass_rate) * 100
```
Where `avg_pass_rate` is the average of (passed_assessments / valid_assessments) per submission.

**Interpretation:** Percentage of screening criteria that pass on average.  
**Trend:** Should increase over time as quality improves (58% → 71.8% from 2023 to 2025).

### 3. Capacity vs Target Percentage
```sql
taskus_capacity_vs_target_pct = (taskus_monthly_screening_capacity / 855) * 100
internal_capacity_vs_target_pct = (internal_monthly_screening_capacity / 108) * 100
```

**Target Derivation:**
- TaskUs: 855 = 19 FTE × 45 screenings/FTE
- Internal: 108 = 6 FTE × 18 screenings/FTE

**Interpretation:**
- 100% = Meeting target capacity
- <100% = Under-resourced
- >100% = Over-resourced relative to target

### 4. Screening Output vs Target (NEW)
```sql
taskus_screening_output_vs_target_pct = (taskus_screenings_per_fte / 45) * 100
internal_screening_output_vs_target_pct = (internal_screenings_per_fte / 18) * 100
```

**Purpose:** Measures actual individual productivity against monthly output targets.

**Interpretation:**
- 100% = Reviewers hitting expected output
- <100% = Underperforming on screening volume
- >100% = Exceeding target output

**Key Difference from Capacity:**
- **Capacity** = theoretical max based on headcount
- **Output** = actual performance achieved

### 5. Workload Level Classification

**TaskUs Workload:**
```sql
CASE 
  WHEN submissions_per_head_taskus > 24 THEN 'High'
  WHEN submissions_per_head_taskus > 20 THEN 'Medium' 
  ELSE 'Normal'
END
```

**Internal Workload:**
```sql
CASE 
  WHEN submissions_per_head_internal > 35 THEN 'High'
  WHEN submissions_per_head_internal > 25 THEN 'Medium'
  ELSE 'Normal' 
END
```

**Purpose:** Quick indicator of team workload pressure.

---

## Target Metrics (Constants)

| Metric | Value | Description |
|--------|-------|-------------|
| `taskus_hours_per_week_target` | 760 | Weekly attended hours for 19 FTE (40 hrs × 19) |
| `internal_hours_per_week_target` | 240 | Weekly attended hours for 6 FTE (40 hrs × 6) |
| `taskus_screenings_per_month_target` | 855 | Total monthly target (19 FTE × 45) |
| `internal_screenings_per_month_target` | 108 | Total monthly target (6 FTE × 18) |
| `quality_per_month_target` | 90 | Quality score target |
| `taskus_individual_monthly_screenings_target` | 45 | Per-FTE monthly screening output |
| `taskus_individual_quality_score_target` | 90 | Quality target per specialist |
| `internal_individual_monthly_screenings_target` | 18 | Per-FTE monthly screening output |

---

## Output Columns Reference

### Dimensional Fields
- `submission_month` - First day of month (DATE)
- `year`, `month`, `month_name` - Date components
- `data_type` - 'Actual' or 'Forecast'

### Core Metrics (15 columns)
1. `app_submission_first` - First-time submissions
2. `app_submission_re` - Resubmissions
3. `app_submission_total` - Total submissions
4. `resubmission_rate_pct` - Calculated ratio
5. `app_publish` - Approved submissions
6. `avg_time_to_publish_days` - Days from submission to approval
7. `assessment_pass_rate_pct` - Quality score
8. `total_assessments_performed` - Total assessment events

### Headcount (3 columns)
9. `headcount_taskus`
10. `headcount_internal`
11. `headcount_total`

### Submission Productivity (3 columns)
12. `submissions_per_head_taskus`
13. `submissions_per_head_total`
14. `submissions_per_head_internal`

### Assessment Productivity (2 columns)
15. `assessments_per_head_taskus`
16. `assessments_per_head_total`

### App Screening Actuals (5 columns) - NEW
17. `taskus_actual_screenings` - Total screenings by TaskUs team
18. `internal_actual_screenings` - Total screenings by Internal team
19. `total_actual_screenings` - Combined total
20. `taskus_screenings_per_fte` - Actual output per TaskUs FTE
21. `internal_screenings_per_fte` - Actual output per Internal FTE

### Capacity Metrics (3 columns)
22. `taskus_monthly_screening_capacity` - Theoretical max
23. `internal_monthly_screening_capacity` - Theoretical max
24. `forecasted_screenings_per_submission` - Expected screening load

### Targets (8 columns)
25-32. All target constants listed above

### Performance Indicators (4 columns) - 2 NEW
33. `taskus_capacity_vs_target_pct`
34. `internal_capacity_vs_target_pct`
35. `taskus_screening_output_vs_target_pct` - NEW: Actual vs target
36. `internal_screening_output_vs_target_pct` - NEW: Actual vs target

### Workload Indicators (2 columns)
37. `taskus_workload_level` - High/Medium/Normal
38. `internal_workload_level` - High/Medium/Normal

**Total Output Columns: 38**

---

## Key Differences from Previous Version

### 1. App Screening Tracking
**Previous:** Only theoretical capacity calculations  
**Current:** Actual screening counts from `app_store_app_submission_reviews_v1`

**Impact:** Can now measure individual productivity against targets.

### 2. Data Source Accuracy
**Previous:** May have used incorrect field names  
**Current:** Uses correct schema fields:
- `UNNEST(reviewers)` for reviewer activity
- `reviewer.review_date` for timing
- `latest_review_state` for filtering

### 3. New Performance Metrics
- `taskus_actual_screenings` - Actual work performed
- `taskus_screenings_per_fte` - Individual productivity
- `taskus_screening_output_vs_target_pct` - Performance measurement

**Impact:** Can now track whether 45 screenings/FTE target is being met.

---

## Usage Recommendations

### For Capacity Planning
- Compare `headcount_taskus` with `submissions_per_head_taskus`
- Monitor `taskus_capacity_vs_target_pct` trends
- Check `workload_level` for pressure indicators

### For Performance Management
- Track `taskus_screenings_per_fte` against 45/month target
- Use `taskus_screening_output_vs_target_pct` for individual team performance
- Monitor `assessment_pass_rate_pct` for quality trends

### For Forecasting
- Review forecast months (data_type = 'Forecast')
- Compare forecasted headcount with capacity needs
- Validate assumptions against actual data as it becomes available

### For Quality Analysis
- Track `assessment_pass_rate_pct` trends over time
- Compare `resubmission_rate_pct` with pass rates
- Monitor `avg_time_to_publish_days` for efficiency

---

## Notes & Assumptions

1. **60-Minute Validity Window:** Only assessments marked as valid within 60 minutes are counted toward quality metrics.

2. **First vs Resubmission:** Determined by `is_first_submission_review` flag in source data.

3. **Primary Reviewer:** Uses APPROX_TOP_COUNT to identify the reviewer who performed the most assessments on each submission.

4. **Screening Definition:** Any action on a submission review that isn't in 'SUBMITTED' or 'WITHDRAWN' state counts as a screening.

5. **Forecast Assumptions:**
   - 2026 growth: 7% over 2025
   - Headcount: Modest increase (19→20 TaskUs, 6→7 Internal)
   - Resubmission rate: Improves to ~20%

6. **Target Basis:** The 45 screenings/FTE target represents expected monthly output for TaskUs specialists at target capacity.

---

## Query Performance Considerations

- **Date Range:** 2023-2027 (covers 4+ years of data)
- **UNNEST Operation:** May be expensive on large datasets; consider filtering dates earlier if performance issues arise
- **Aggregation Levels:** Monthly aggregation reduces row count significantly
- **JOIN Strategy:** LEFT JOINs ensure all data retained even without reviewer matches

---

*Last Updated: October 2025*  
*Query Version: 2.0 (with App Screenings)*

