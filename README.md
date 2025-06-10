# ecosystem-operations-review-excellence
Queries for App Review &amp; Excellence Looker dashboard

# Reviewer Efficiency Metric: Overview & Interpretation

## What is the Reviewer Efficiency Metric?

The **reviewer_efficiency_metric** is a quantitative measure designed to capture an app reviewer's overall effectiveness in the Shopify App Review process. It combines three major dimensions:

- **Productivity:** Volume of reviews completed
- **Complexity:** Work effort & challenge of each review
- **Speed:** How quickly reviews are processed

This all-in-one number makes it easy to compare reviewers and track improvements over time, while accounting for both output and the nature of the work.

---

## How Is It Calculated?

For each reviewer, over a time window (e.g., daily):

reviewer_efficiency_metric =
(apps_published * 1.0
rejection_count * 0.5
total_ticket_updates * 0.1
total_requirements_checked * 0.01)
÷ avg_review_duration_mins

### Component Definitions

- **apps_published**: Approved submissions for the period (full credit, most valuable)
- **rejection_count**: Rejected submissions (partial credit; still work done, not just rubber-stamping)
- **total_ticket_updates**: Support or follow-up actions (worth a little extra credit)
- **total_requirements_checked**: Total number of requirements reviewed (credit for review complexity)
- **avg_review_duration_mins**: Average time (in minutes), per review, capped at 24h per review (to avoid outliers tanking the metric)

### Example Calculation

Suppose a reviewer, for one week:
- Approved 15 apps
- Rejected 3 apps
- Made 4 ticket updates
- Checked 52 requirements
- Average review duration: 90 minutes

Calculation:
(15*1.0) + (3*0.5) + (4*0.1) + (52*0.01) = 15 + 1.5 + 0.4 + 0.52 = **17.42**

Efficiency = 17.42 / 90 = **0.1936**

---

## Why These Weights?

- **Approvals (1.0):** This is the core output, so it's weighted highest.
- **Rejections (0.5):** Still valuable (work has to be done), but less so than an approval.
- **Ticket Updates (0.1):** Indicates more work, complex/unclear cases, process improvement.
- **Requirements Checked (0.01):** Reviewing more requirements equates to reviewing more complex or thorough submissions.

*Weights can be changed as needs or review priorities evolve.*

---

## How Should We Interpret the Metric?

- **Higher is better:** A higher value means a reviewer is consistently processing more apps (more complex ones), faster.
- **Low metric:** Could mean slow reviews, low output, or a focus on highly complex/edge cases.
- **Compare within similar groups:** Use the metric primarily among reviewers at the same tier or with similar review mixes (to ensure fairness).

**Example Guideline:**
- Top performers often have both high output _and_ steady speed.
- Occasional lower scores may indicate attention on especially challenging submissions, and that's OK as long as it aligns with work type and team goals.

---

## Caveats & Recommendations

- Do **not** use this as the only performance measure; always look at context and qualitative factors.
- Outliers: The 24h cap on review duration mitigates but doesn't eliminate all oddities—context still matters.
- Encourage transparency: Drilldowns are possible to see which work “makes up” the metric.

---

## FAQ

**Q: If someone only does hard cases, could their metric be misleadingly low?**
A: Yes—the metric rewards output and speed, so context is key! Always supplement with qualitative feedback.

**Q: What if my metric drops suddenly?**
A: Check for longer review times (maybe due to tougher apps) or lower submission volume.

**Q: Can we change the weights?**
A: Absolutely. These were chosen for a balance of simplicity and fairness but are fully adjustable.

---

For questions or implementation help, ask the Data & Ops team!
