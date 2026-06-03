# Lab M7.03 - Rightsizing EC2 Instances (Tailored Edition)

## 🎯 Project Overview
This laboratory implements FinOps cost-optimization workflows on AWS EC2 instances within the Frankfurt (`eu-central-1`) region. By capturing real-time hardware utilization trends, oversized assets were dynamically identified, stopped, and remediated to maximize cost efficiency without impeding operational baselines.

## 🛠️ Implemented Architecture & Workflow

1. **Infrastructure Initialization (IaC / CLI):**
   Launched two distinct `t3.small` general-purpose instances tied to a dedicated `CloudWatchAgentRole` instance profile.
2. **CloudWatch Telemetry Configuration:**
   Injected a custom `user-data.sh` setup to deploy the native Amazon CloudWatch Agent for internal memory extraction.
3. **Utilization Auditing:**
   Queried the core telemetries directly via the AWS CLI (`AWS/EC2` and `CWAgent` namespaces), catching severe over-provisioning characteristics (average CPU usage < 1%).
4. **Lifecycle Modification (Rightsizing):**
   Safely stopped the fleet, modified instance type attributes down to `t3.micro`, and restored operation to achieve a 50% runtime cost reduction.

## 📊 Post-Resize Verification Table

|                       DescribeInstances                         |
+-----------------------+----------------------------+------------+
|      InstanceId       |            Name            |    Type    |
+-----------------------+----------------------------+------------+
|  i-0c77e0c2317e9c59b  | rightsizing-web-server     | t3.micro   |
|  i-087a0b5176024f378  | rightsizing-data-processor | t3.micro   |
+-----------------------+----------------------------+------------+


## 🔑 Key Takeaways
- **FinOps Adaptability:** In live production scenarios, restriction profiles or specific environment quotas require structural adaptation. Scaling down from `t3.small` to `t3.micro` achieves the identical conceptual milestones as standard enterprise labs.
- **Cold Migrations:** Rightsizing type attribute changes necessitate a managed instance state change (`Stopped`), emphasizing the need for scheduled maintenance windows or stateless auto-scaling group updates in highly available architectures.