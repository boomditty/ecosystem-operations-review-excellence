# Looker Studio Visualization Guide - App Review Forecast Dashboard

## 🔌 **Data Connection Setup**

### **1. Connect BigQuery Data Source**
1. **Open Looker Studio** → Create new report
2. **Add Data Source** → BigQuery
3. **Select Project**: `shopify-dw`
4. **Custom Query**: Paste your `complete_forecast_query_assessments.sql`
5. **Enable Data Freshness**: Set to refresh every 4-8 hours

### **2. Key Field Configurations**
Configure these fields in Looker Studio:

| Field Name | Type | Format | Description |
|------------|------|---------|-------------|
| `submission_month` | Date | YYYY-MM | Primary time dimension |
| `data_type` | Text | Category | Actual vs Forecast filter |
| `app_submission_total` | Number | #,##0 | Core volume metric |
| `taskus_capacity_vs_target_pct` | Number | 0.0% | Percentage format |
| `workload_level` | Text | Category | Color coding needed |

---

## 📊 **Dashboard Layout Structure**

### **Top Section: Executive Summary (KPIs)**
4 scorecards in a row showing current month performance:

#### **Scorecard 1: Monthly Submissions**
```
Chart Type: Scorecard
Metric: app_submission_total (current month)
Comparison: Previous month % change
Color: Blue (#1f77b4)
```

#### **Scorecard 2: Team Capacity**
```
Chart Type: Scorecard  
Metric: taskus_capacity_vs_target_pct (current month)
Comparison: Target (100%)
Conditional Formatting:
- >100%: Green
- 85-100%: Yellow  
- <85%: Red
```

#### **Scorecard 3: Quality Rate**
```
Chart Type: Scorecard
Metric: assessment_pass_rate_pct (current month)
Comparison: Target (90%)
Color: Green if >90%, Red if <90%
```

#### **Scorecard 4: Time to Publish**
```
Chart Type: Scorecard
Metric: avg_time_to_publish_days (current month)
Comparison: Previous month
Color: Green if decreasing, Red if increasing
```

---

## 📈 **Main Charts Section**

### **Chart 1: Submission Volume Trends (Primary)**
```
Chart Type: Combo Chart (Line + Column)
Dimensions: submission_month
Metrics: 
  - app_submission_first (Column, Blue)
  - app_submission_re (Column, Orange, Stacked)
  - app_publish (Line, Green)
Series:
  - Filter by data_type for Actual vs Forecast
  - Add trendline to show growth patterns
Size: Full width (12 columns)
```

### **Chart 2: Headcount & Productivity**
```
Chart Type: Combo Chart
Dimensions: submission_month
Left Axis:
  - headcount_total (Column, Gray)
  - headcount_taskus (Column, Blue)
Right Axis:
  - submissions_per_head_taskus (Line, Red)
Configuration:
  - Dual axis for different scales
  - Show data labels on lines
Size: Half width (6 columns)
```

### **Chart 3: Capacity Utilization**
```
Chart Type: Gauge Chart
Metric: taskus_capacity_vs_target_pct (latest month)
Configuration:
  - Min: 0%, Max: 120%
  - Green zone: 85-115%
  - Red zone: <85% or >115%
  - Target line at 100%
Size: Quarter width (3 columns)
```

### **Chart 4: Quality Metrics**
```
Chart Type: Line Chart
Dimensions: submission_month
Metrics:
  - assessment_pass_rate_pct (Line, Blue)
  - Target line at 90% (Reference line)
Configuration:
  - Y-axis: 80-100%
  - Show data points
Size: Quarter width (3 columns)
```

---

## 📋 **Detailed Analysis Section**

### **Chart 5: Workload Analysis Table**
```
Chart Type: Table
Dimensions: 
  - submission_month
  - data_type
Metrics:
  - app_submission_total
  - headcount_taskus
  - submissions_per_head_taskus
  - taskus_workload_level
Conditional Formatting:
  - High workload: Red background
  - Medium workload: Yellow background
  - Normal workload: Green background
Sort: submission_month DESC
Size: Full width (12 columns)
```

### **Chart 6: Forecast vs Actual Comparison**
```
Chart Type: Column Chart
Dimensions: submission_month (filter to current year)
Metrics: app_submission_total
Series: data_type (Actual vs Forecast)
Configuration:
  - Side-by-side columns
  - Blue for Actual, Orange for Forecast
  - Show variance percentage
Size: Half width (6 columns)
```

### **Chart 7: Team Performance Breakdown**
```
Chart Type: Stacked Column
Dimensions: submission_month
Metrics:
  - TaskUs submissions (calculated field)
  - Internal submissions (calculated field)
Configuration:
  - Calculate based on headcount proportions
  - Blue for TaskUs, Green for Internal
Size: Half width (6 columns)
```

---

## 🎛️ **Interactive Controls**

### **Filter Controls (Top of Dashboard)**

#### **Date Range Filter**
```
Control Type: Date Range Picker
Field: submission_month
Default: Last 12 months
Position: Top left
```

#### **Data Type Filter**
```
Control Type: Drop-down List
Field: data_type
Options: All, Actual, Forecast
Default: All
Position: Top center
```

#### **Workload Level Filter**
```
Control Type: Multi-select
Field: taskus_workload_level
Options: Normal, Medium, High
Default: All selected
Position: Top right
```

---

## 📊 **Advanced Visualizations**

### **Chart 8: Seasonal Pattern Analysis**
```
Chart Type: Heat Map
Dimensions: 
  - MONTH(submission_month) (rows)
  - YEAR(submission_month) (columns)
Metric: app_submission_total
Configuration:
  - Color scale: Light to dark blue
  - Show patterns across years
Size: Half width (6 columns)
```

### **Chart 9: Efficiency Trend**
```
Chart Type: Scatter Plot
Dimensions: submission_month
X-axis: submissions_per_head_taskus
Y-axis: assessment_pass_rate_pct
Size: app_submission_total
Color: data_type
Configuration:
  - Trendline enabled
  - Quadrant lines at averages
Size: Half width (6 columns)
```

---

## 🎨 **Styling & Branding**

### **Color Scheme**
- **Primary Blue**: #1f77b4 (Actual data)
- **Orange**: #ff7f0e (Forecast data)
- **Green**: #2ca02c (Positive metrics)
- **Red**: #d62728 (Alert metrics)
- **Gray**: #7f7f7f (Supporting data)

### **Typography**
- **Dashboard Title**: 24px, Bold
- **Section Headers**: 18px, Semi-bold
- **Chart Titles**: 14px, Bold
- **Data Labels**: 12px, Regular

### **Layout Grid**
- Use 12-column grid system
- 20px padding between charts
- Consistent chart heights within rows

---

## 📱 **Mobile Responsiveness**

### **Mobile Layout Adjustments**
1. **Stack scorecards vertically** (4 rows instead of 1 row)
2. **Simplify combo charts** to single metric charts
3. **Hide detailed table** on mobile, show summary only
4. **Increase font sizes** by 2px for readability

---

## 🔄 **Calculated Fields**

### **Essential Calculated Fields to Create**

#### **1. Current Month Filter**
```sql
CASE 
  WHEN submission_month = MAX(submission_month) THEN "Current Month"
  ELSE "Historical"
END
```

#### **2. Capacity Status**
```sql
CASE 
  WHEN taskus_capacity_vs_target_pct >= 100 THEN "At/Above Target"
  WHEN taskus_capacity_vs_target_pct >= 85 THEN "Near Target"
  ELSE "Below Target"
END
```

#### **3. YoY Growth**
```sql
(app_submission_total - LAG(app_submission_total, 12) OVER (ORDER BY submission_month)) 
/ LAG(app_submission_total, 12) OVER (ORDER BY submission_month) * 100
```

---

## 🎯 **Dashboard Performance Tips**

### **Optimization Strategies**
1. **Limit date range** to 24 months for faster loading
2. **Use aggregated data** at monthly level (already done in query)
3. **Enable data caching** with 4-hour refresh
4. **Minimize real-time queries** - use scheduled refreshes

### **User Experience**
1. **Add tooltips** explaining key metrics
2. **Include data source timestamp** in footer
3. **Add "last updated" indicator**
4. **Provide export options** for key tables

---

## 📋 **Dashboard Checklist**

### **Before Publishing**
- [ ] All charts load within 10 seconds
- [ ] Color coding is consistent across charts
- [ ] Filters affect all relevant charts
- [ ] Mobile view is readable and functional
- [ ] Data accuracy verified against source
- [ ] Tooltips provide meaningful context
- [ ] Export functionality works for key data

### **After Publishing**
- [ ] Share with stakeholders for feedback
- [ ] Set up automated email reports
- [ ] Create user access permissions
- [ ] Document dashboard usage instructions
- [ ] Schedule regular data refresh monitoring

---

This comprehensive setup will create a professional, interactive dashboard that leverages all the rich data from your forecast query while providing intuitive navigation and insights for different user types! 📊
