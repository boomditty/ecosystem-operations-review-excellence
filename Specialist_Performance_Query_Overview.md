# Specialist Performance Management Query - Overview

## 🎯 **Purpose**
This query transforms the team-level forecasting approach into **individual specialist performance analytics** for management, coaching, and development purposes.

## 🔄 **Key Differences from Forecast Query**

| Aspect | Forecast Query | Specialist Performance Query |
|--------|----------------|------------------------------|
| **Focus** | Team capacity planning | Individual performance management |
| **Granularity** | Monthly team aggregates | Monthly per-specialist metrics |
| **Output** | Operational forecasting | Performance reviews & coaching |
| **Timeframe** | 2-year forecasting | Last 6 months trending |

---

## 📊 **Individual Performance Metrics**

### **Volume & Productivity**
- **`total_assessments`** - Total valid assessments completed
- **`unique_submissions_worked`** - Number of distinct app submissions handled
- **`active_days`** - Days the specialist performed assessments
- **`assessments_per_active_day`** - Daily productivity rate
- **`submissions_per_active_day`** - Daily submission handling rate

### **Quality & Accuracy**
- **`pass_rate_pct`** - Percentage of assessments that passed
- **`fail_rate_pct`** - Percentage of assessments that failed
- **`core_blocking_pct`** - Percentage working on critical blocking criteria
- **`automation_agreement_pct`** - Agreement rate with automated checks

### **Specialization Analysis**
- **`new_app_focus_pct`** - Percentage of work on first-time submissions
- **`human_catch_rate_pct`** - Issues caught that automation missed
- **`core_blocking_assessments`** - Volume of critical screening work

---

## 🏆 **Performance Rankings & Comparisons**

### **Peer Rankings** (Within Same Tier & Month)
- **`volume_rank`** - Ranked by total assessments completed
- **`quality_rank`** - Ranked by pass rate percentage  
- **`efficiency_rank`** - Ranked by assessments per active day

### **Peer Comparisons**
- **`assessments_vs_peer_avg`** - Volume above/below peer average
- **`quality_vs_peer_avg`** - Quality above/below peer average
- **`efficiency_vs_peer_avg`** - Efficiency above/below peer average

---

## 🎯 **Performance Categories**

### **Overall Performance Rating**
- **Top Performer**: High volume + high quality (ranks 1-3 volume, 1-5 quality)
- **Strong Performer**: Good volume + good quality (ranks 1-5 volume, 1-10 quality)
- **Solid Performer**: Consistent, reliable performance
- **Needs Support**: Quality <85% or bottom 20% efficiency

### **Development Focus Areas**
- **Quality Training**: Pass rate <90%
- **Productivity Coaching**: <15 assessments/day
- **Automation Alignment**: <80% agreement with automated checks
- **Advanced Training**: >20% human-only catches
- **Maintain Excellence**: No specific development needs

---

## 📈 **Workload & Quality Indicators**

### **Workload Levels**
- **High Workload**: >25 assessments/day
- **Medium Workload**: 20-25 assessments/day  
- **Normal Workload**: <20 assessments/day

### **Quality Levels**
- **Excellent Quality**: ≥95% pass rate
- **Good Quality**: 90-94% pass rate
- **Acceptable Quality**: 85-89% pass rate
- **Needs Improvement**: <85% pass rate

---

## 🔧 **Management Applications**

### **Performance Reviews**
- Individual specialist scorecards
- Peer benchmarking within tier/squad
- Trend analysis over 6-month periods
- Objective performance data for evaluations

### **Coaching & Development**
- Identifies specific improvement areas
- Tracks coaching effectiveness over time
- Highlights specialists needing support
- Recognizes top performers for mentoring roles

### **Workload Management** 
- Identifies overloaded specialists
- Balances assignment distribution
- Monitors burnout risk indicators
- Optimizes team capacity allocation

### **Training & Development**
- Pinpoints skill gaps (quality vs automation)
- Identifies specialization opportunities
- Tracks training program effectiveness
- Plans career development pathways

---

## 📊 **Sample Insights**

### **Top Performer Example**
```
Jane Doe | TaskUs Tier 2 | March 2025
- 847 assessments (Rank #1 in tier)
- 96.2% pass rate (Rank #2 in tier) 
- 28.4 assessments/day (High workload, excellent efficiency)
- Performance: "Top Performer"
- Development: "Maintain Excellence"
```

### **Development Opportunity Example**
```
John Smith | TaskUs Tier 2 | March 2025
- 423 assessments (Rank #12 in tier)
- 82.1% pass rate (Below peer avg by -7.3%)
- 16.2 assessments/day (Normal workload)
- Performance: "Needs Support" 
- Development: "Quality Training"
```

---

## ⚡ **Query Features**

### **Performance Filtering**
- Minimum 10 assessments for meaningful analysis
- Last 6 months for relevant trending
- Valid assessments only (60-minute rule)

### **Automated Insights**
- Performance categories auto-assigned
- Development focus auto-identified  
- Workload and quality levels auto-calculated
- Peer comparisons auto-computed

This query transforms operational data into actionable performance management insights! 🎯

