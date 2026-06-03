# EC2 Infrastructure Rightsizing Audit Report

## 🔬 Analysis Summary
- **Audit Date:** 2026-06-03
- **Duration:** 30 minutes of metric evaluation
- **Methodology:** Local account environment analysis via AWS CloudWatch metrics
- **Core Objective:** Optimize infrastructure spend by downsizing severely over-provisioned staging/development workloads.

## 📊 Instance Resource Utilization Audit

| Instance Name | Instance ID | Original Type | vCPUs | RAM (GB) | Avg CPU % | Avg Mem % | Recommendation | Target Type | Monthly Savings |
|---|---|---|---|---|---|---|---|---|---|
| rightsizing-web-server | i-0c77e0c2317e9c59b | t3.small | 2 | 2 | 0.61% | <10.0% | **Downsize** | t3.micro | $9.05 |
| rightsizing-data-processor | i-087a0b5176024f378 | t3.small | 2 | 2 | 0.53% | <10.0% | **Downsize** | t3.micro | $9.05 |

## 💰 Cost Optimization Reference (eu-central-1, Frankfurt)
- `t3.small` On-Demand Price: ~$0.0248/hr $\rightarrow$ ~$18.10/mo per instance
- `t3.micro` On-Demand Price: ~$0.0124/hr $\rightarrow$ ~$9.05/mo per instance

### 📉 Financial Impact
- **Cost Reduction per Fleet Component:** **50% Total Spend Cut**
- **Total Projected Monthly Savings:** **$18.10 / month**

## 📝 Engineering Decisions
1. **rightsizing-web-server:** Initial idle metrics (<1% CPU) indicate that a burstable general-purpose `t3.micro` is more than sufficient to handle baseline tasks while utilizing CPU Credits for occasional peaks.
2. **rightsizing-data-processor:** Severely over-provisioned during initial rollout. Downsized to `t3.micro` to align resource boundaries with actual workload demands.- Extra Mile: Created automated shell auditing tool and automated CloudWatch FinOps thresholds.
