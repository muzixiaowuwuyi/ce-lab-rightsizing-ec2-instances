#!/usr/bin/env bash
# rightsizing-csv.sh — Automated FinOps fleet auditing tool

echo "InstanceId,Name,Type,vCPUs,AvgCPU%,Status"

# 获取当前配置的区域
REGION=$(aws configure get region)
END_TIME=$(date -u '+%Y-%m-%dT%H:%M:%S')
# 鉴于我们是刚开机的新实例，将审计窗口设为过去 1 小时以确保能抓到刚才的数据点
START_TIME=$(date -u -d '1 hour ago' '+%Y-%m-%dT%H:%M:%S')

# 1. 扫描所有运行中的实例
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[].Instances[].[InstanceId,InstanceType,Tags[?Key==`Name`].Value|[0]]' \
  --output text | while read -r ID TYPE NAME; do

  # 2. 动态查询该规格对应的 vCPU 数量
  VCPUS=$(aws ec2 describe-instance-types --instance-types "$TYPE" \
    --query 'InstanceTypes[0].VCpuInfo.DefaultVCpus' --output text)

  # 3. 抽取 CloudWatch 均值 CPU
  AVG_CPU=$(aws cloudwatch get-metric-statistics \
    --namespace AWS/EC2 \
    --metric-name CPUUtilization \
    --dimensions Name=InstanceId,Value="$ID" \
    --start-time "$START_TIME" \
    --end-time "$END_TIME" \
    --period 300 \
    --statistics Average \
    --query 'Datapoints[].Average | [0]' --output text 2>/dev/null)

  # 4. 处理无数据点的冷实例
  if [[ "$AVG_CPU" == "None" || -z "$AVG_CPU" ]]; then
    STATUS="NO_DATA"
    AVG_CPU="N/A"
  else
    # 5. FinOps 阈值状态断言
    if (( $(echo "$AVG_CPU < 10.0" | bc -l) )); then
      STATUS="OVERSIZED"
    elif (( $(echo "$AVG_CPU > 80.0" | bc -l) )); then
      STATUS="UNDERSIZED"
    else
      STATUS="RIGHT_SIZED"
    fi
  fi

  # 6. 标准 CSV 输出
  echo "$ID,${NAME:-unnamed},$TYPE,$VCPUS,$AVG_CPU,$STATUS"
done
