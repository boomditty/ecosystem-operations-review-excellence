# Complete Forecast Query Assessments - Change Log

## Summary of Changes

This document outlines all modifications made to the original `complete_forecast_query_assessments.sql` to incorporate actual app screening data from the `app_store_app_submission_reviews_v1` table.

---

## Version History

**Original Version:** Assessment-based metrics only  
**Updated Version:** Assessment metrics + App screening activity tracking  
**Date Updated:** October 2025

---

## Major Additions

### 1. New Data Source Integration
**Added:** `app_store_app_submission_reviews_v1` table for tracking actual reviewer activity

**Purpose:** Measure actual monthly screening output against the 45 screenings/FTE target for TaskUs specialists.

---

## Detailed Changes

### A. New CTEs Added (2 new)

#### 1. **app_screenings** CTE (NEW)
```sql
-- App screenings data (excluding SUBMITTED and WITHDRAWN states)
-- Counts distinct app reviews worked on by each reviewer per month
-- Uses UNNEST on reviewers array to get individual reviewer activity
app_screenings AS (
  SELECT
    DATE(DATE_TRUNC(reviewer.review_date, MONTH)) AS screening_month,
    reviewer.reviewer_name AS reviewed_by,
    COUNT(DISTINCT r.app_store_app_submission_review_id) AS screening_count
  FROM 
    `shopify-dw.apps_and_developers.app_store_app_submission_reviews_v1` r,
    UNNEST(r.reviewers) AS reviewer
  WHERE
    reviewer.review_date >= '2023-01-01'
    AND reviewer.review_date < '2027-01-01'
    AND r.latest_review_state NOT IN ('SUBMITTED', 'WITHDRAWN')
  GROUP BY
    screening_month,
    reviewed_by
)
```

**What it does:**
- Extracts individual reviewer activity from the `reviewers` array using UNNEST
- Counts distinct submission reviews each reviewer worked on per month
- Excludes reviews in SUBMITTED or WITHDRAWN states (no actual screening work)
- Groups by review_date (when work occurred) and reviewer_name

**Key Schema Corrections Made:**
- ❌ `created_at` → ✅ `reviewer.review_date` (created_at doesn't exist)
- ❌ `reviewed_by` → ✅ `reviewer.reviewer_name` (must access via UNNEST)
- ❌ `status` → ✅ `latest_review_state` (status doesn't exist)

#### 2. **monthly_screenings** CTE (NEW)
```sql
-- Aggregate screenings by month and reviewer type
monthly_screenings AS (
  SELECT
    aps.screening_month,
    SUM(CASE WHEN rm.review_tier != 'Internal' THEN aps.screening_count ELSE 0 END) AS taskus_screenings,
    SUM(CASE WHEN rm.review_tier = 'Internal' THEN aps.screening_count ELSE 0 END) AS internal_screenings,
    SUM(aps.screening_count) AS total_screenings
  FROM app_screenings aps
  LEFT JOIN reviewer_metadata rm ON aps.reviewed_by = rm.reviewed_by
  GROUP BY screening_month
)
```

**What it does:**
- Aggregates individual reviewer screenings to monthly team totals
- Separates TaskUs vs Internal screening counts
- Joins with reviewer_metadata to classify reviewers

**Note:** Changed alias from `asc` to `aps` to avoid SQL reserved keyword conflict.

---

### B. Modified CTEs (3 updated)

#### 1. **actual_data** CTE - Added Screening Metrics
**Added 3 new fields:**
```sql
-- App screening metrics from monthly_screenings
MAX(ms.taskus_screenings) AS taskus_actual_screenings,
MAX(ms.internal_screenings) AS internal_actual_screenings,
MAX(ms.total_screenings) AS total_actual_screenings
```

**Added JOIN:**
```sql
LEFT JOIN
  monthly_screenings ms ON DATE(DATE_TRUNC(ss.submitted_at, MONTH)) = ms.screening_month
```

**Impact:** Brings actual screening counts into the monthly aggregation for historical data.

#### 2. **forecast_data** CTE - Added Screening Placeholders
**Added NULL placeholders for 3 new fields:**
```sql
-- App screening forecasts (based on target of 45 per TaskUs FTE)
CAST(NULL AS INT64) AS taskus_actual_screenings,
CAST(NULL AS INT64) AS internal_actual_screenings,
CAST(NULL AS INT64) AS total_actual_screenings
```

**Impact:** Maintains column consistency between actual and forecast data; screenings can't be forecasted at individual level.

#### 3. **combined_data** CTE - Added Screening Calculations

**Added to both UNION branches:**

**New Pass-Through Fields:**
```sql
-- App screening actuals
taskus_actual_screenings,
internal_actual_screenings,
total_actual_screenings,
```

**New Productivity Calculations:**
```sql
-- App screening productivity (actual screenings per FTE)
ROUND(SAFE_DIVIDE(CAST(taskus_actual_screenings AS FLOAT64), 
                  CAST(NULLIF(headcount_taskus, 0) AS FLOAT64)), 1) AS taskus_screenings_per_fte,
ROUND(SAFE_DIVIDE(CAST(internal_actual_screenings AS FLOAT64), 
                  CAST(NULLIF(headcount_internal, 0) AS FLOAT64)), 1) AS internal_screenings_per_fte,
```

**In Forecast Branch:**
```sql
-- App screening productivity (NULL for forecasts)
CAST(NULL AS FLOAT64) AS taskus_screenings_per_fte,
CAST(NULL AS FLOAT64) AS internal_screenings_per_fte,
```

**Impact:** Calculates actual screening output per FTE, enabling comparison to 45/month target.

---

### C. Final SELECT Statement - Added Output Columns

**Added 7 new output columns:**

```sql
-- App screening actuals and productivity
taskus_actual_screenings,                              -- NEW: Total TaskUs screenings
internal_actual_screenings,                            -- NEW: Total Internal screenings
total_actual_screenings,                               -- NEW: Combined total
taskus_screenings_per_fte,                            -- NEW: Actual per-FTE output
internal_screenings_per_fte,                          -- NEW: Actual per-FTE output
```

**Added 2 new performance indicators:**
```sql
-- App screening performance vs target (actual screenings per FTE vs 45 target)
ROUND(SAFE_DIVIDE(taskus_screenings_per_fte, 45.0) * 100, 1) AS taskus_screening_output_vs_target_pct,     -- NEW
ROUND(SAFE_DIVIDE(internal_screenings_per_fte, 18.0) * 100, 1) AS internal_screening_output_vs_target_pct,  -- NEW
```

**Updated comment documentation:**
```sql
-- SLA targets (constant values from your dashboard)
760 AS taskus_hours_per_week_target,  -- Weekly attended hours for 19 FTE
240 AS internal_hours_per_week_target,
855 AS taskus_screenings_per_month_target,  -- 19 FTE * 45 screenings per FTE
108 AS internal_screenings_per_month_target,
90 AS quality_per_month_target,
45 AS taskus_individual_monthly_screenings_target,  -- Monthly output per TaskUs FTE
90 AS taskus_individual_quality_score_target,
18 AS internal_individual_monthly_screenings_target,
```

---

### D. Query Header Documentation Updates

**Updated from:**
```sql
-- Complete App Review Forecast Query - Using Assessments Table
-- Combines historical data with 2025-2026 forecasts (24 months total)
-- Updated to use app_store_app_submission_review_assessments_v1
```

**Updated to:**
```sql
-- Complete App Review Forecast Query - Using Assessments Table
-- Combines historical data with 2025-2026 forecasts (24 months total)
-- Updated to use app_store_app_submission_review_assessments_v1
-- Includes actual app screening data from app_store_app_submission_reviews_v1
--   - Uses UNNEST(reviewers) to extract individual reviewer activity from reviewers array
--   - Filters by latest_review_state (not 'SUBMITTED' or 'WITHDRAWN')
--   - Groups by reviewer.review_date and reviewer.reviewer_name
-- TaskUs Target: 760 weekly attended hours (19 FTE), 45 app screenings per FTE monthly
```

---

## Output Schema Changes

### Original Output: 31 columns
1-31: All original metrics (submissions, assessments, headcount, productivity, targets, workload)

### Updated Output: 38 columns (+7)
1-31: All original metrics (unchanged)  
**32. taskus_actual_screenings** - NEW  
**33. internal_actual_screenings** - NEW  
**34. total_actual_screenings** - NEW  
**35. taskus_screenings_per_fte** - NEW  
**36. internal_screenings_per_fte** - NEW  
**37. taskus_screening_output_vs_target_pct** - NEW  
**38. internal_screening_output_vs_target_pct** - NEW  

---

## Calculation Logic Changes

### New Calculations Added

#### 1. Screening Count Per Reviewer Per Month
```sql
COUNT(DISTINCT app_store_app_submission_review_id)
WHERE latest_review_state NOT IN ('SUBMITTED', 'WITHDRAWN')
GROUP BY DATE_TRUNC(review_date, MONTH), reviewer_name
```

**Definition:** Number of unique submission reviews a specialist worked on in a month (excluding non-screened submissions).

#### 2. Screenings Per FTE
```sql
taskus_screenings_per_fte = taskus_actual_screenings / headcount_taskus
```

**Purpose:** Measures actual individual productivity.

#### 3. Screening Output vs Target %
```sql
taskus_screening_output_vs_target_pct = (taskus_screenings_per_fte / 45.0) * 100
```

**Purpose:** Compares actual output to the 45 screenings/FTE monthly target.

**Key Difference:**
- **capacity_vs_target_pct** = Theoretical capacity based on headcount × target
- **screening_output_vs_target_pct** = Actual performance achieved

---

## Schema Corrections Made

Based on the actual `app_store_app_submission_reviews_v1` schema:

| Incorrect (Original Assumption) | Correct (Actual Schema) | Fix Applied |
|--------------------------------|-------------------------|-------------|
| `created_at` field | `reviewer.review_date` | Changed to access date from reviewers array |
| `reviewed_by` field | `reviewer.reviewer_name` | Changed to UNNEST and access from array |
| `status` field | `latest_review_state` | Changed to use correct state field |
| Direct reviewer access | UNNEST(reviewers) | Added UNNEST operation |

**Critical Fix:** The reviewers array structure requires UNNEST to extract individual reviewer records.

```sql
-- Schema structure:
reviewers: REPEATED RECORD {
  review_date: DATE
  reviewer_name: STRING
  review_time_seconds: INTEGER
}

-- Access pattern:
FROM table r, UNNEST(r.reviewers) AS reviewer
WHERE reviewer.review_date >= '2023-01-01'
```

---

## Performance Implications

### Positive Impacts:
✅ More accurate screening counts based on actual work performed  
✅ Can now measure individual team productivity  
✅ Enables tracking against 45 screenings/FTE target  
✅ Separates capacity (theoretical) from output (actual)

### Potential Concerns:
⚠️ UNNEST operation may be slower on large datasets  
⚠️ Additional JOIN with monthly_screenings in actual_data  
⚠️ 7 additional columns in output (minor impact)

### Mitigation:
- Date filtering applied early (2023-2027 range)
- Monthly aggregation reduces row count significantly
- LEFT JOIN ensures no data loss

---

## Data Quality Improvements

### 1. More Accurate Screening Definition
**Before:** Theoretical capacity only (headcount × 45)  
**After:** Actual work performed from reviewers array

### 2. Proper State Filtering
**Before:** Potentially counting unscreened submissions  
**After:** Explicitly excludes SUBMITTED and WITHDRAWN states

### 3. Correct Date Attribution
**Before:** May have used submission date  
**After:** Uses actual review_date when work was performed

### 4. Individual Reviewer Attribution
**Before:** Only aggregate headcount  
**After:** Tracks individual reviewer activity, aggregated to totals

---

## Use Case Enhancements

### New Capabilities Enabled:

1. **Performance Management**
   - Track if specialists are meeting 45 screenings/month target
   - Identify underperforming teams or time periods
   - Compare actual vs theoretical capacity

2. **Capacity Planning**
   - See actual utilization, not just theoretical
   - Better forecasting based on real output trends
   - Identify over/under-staffing based on performance

3. **Productivity Analysis**
   - Month-over-month productivity trends
   - Team comparison (TaskUs vs Internal)
   - Workload distribution insights

4. **Target Setting**
   - Validate if 45 screenings/FTE is realistic
   - Adjust targets based on historical achievement
   - Set differentiated targets by team or period

---

## Breaking Changes

### ⚠️ None - All Changes Are Additive

- All original columns retained in same order
- New columns appended to end of output
- All original calculations unchanged
- Backward compatible with existing reports

### Migration Notes:
- Existing dashboards will continue to work
- New columns will appear as additional fields
- May need to update column selection if using SELECT *
- Recommended to update visualizations to include new metrics

---

## Testing Recommendations

### Validation Queries:

1. **Check screening counts are reasonable:**
```sql
SELECT 
  screening_month,
  taskus_screenings_per_fte,
  headcount_taskus,
  taskus_actual_screenings
FROM [output]
WHERE data_type = 'Actual'
ORDER BY screening_month DESC
```

2. **Verify no duplicate counting:**
```sql
-- Screenings per reviewer should not exceed total submissions
SELECT 
  submission_month,
  taskus_actual_screenings,
  app_submission_total,
  ROUND(taskus_actual_screenings / app_submission_total, 2) AS screenings_per_submission
FROM [output]
WHERE data_type = 'Actual'
```

3. **Compare capacity vs output:**
```sql
SELECT 
  submission_month,
  taskus_monthly_screening_capacity AS theoretical,
  taskus_actual_screenings AS actual,
  taskus_screening_output_vs_target_pct AS achievement_pct
FROM [output]
WHERE data_type = 'Actual'
ORDER BY submission_month DESC
```

---

## Known Limitations

1. **Forecast Months:** Screening actuals are NULL for forecasted periods (cannot predict individual performance).

2. **Reviewer Matching:** Depends on exact name match between `reviewers.reviewer_name` and `reviewer_metadata.reviewed_by`.

3. **State Accuracy:** Uses `latest_review_state` - if state changes after review work, count reflects final state.

4. **Multiple Reviewers:** If multiple reviewers work on same submission, each gets credit (by design for workload measurement).

5. **Review Date Granularity:** Uses DATE (day level), loses time-of-day information.

---

## Rollback Plan

If issues arise, revert to original query by:

1. Remove `app_screenings` CTE
2. Remove `monthly_screenings` CTE
3. Remove screening fields from `actual_data`
4. Remove screening fields from `forecast_data`
5. Remove screening calculations from `combined_data`
6. Remove screening columns from final SELECT

**Estimated rollback time:** < 5 minutes

---

## Future Enhancement Opportunities

1. **Time-based analysis:** Add `review_time_seconds` from reviewers array
2. **Quality correlation:** Compare screening volume with pass rates
3. **Reviewer-level output:** Keep individual reviewer metrics instead of aggregating
4. **State transition tracking:** Track time between states using state timestamps
5. **Automated check usage:** Incorporate automated check data for efficiency metrics

---

*Change Log Version: 1.0*  
*Last Updated: October 2025*  
*Author: System Update*

