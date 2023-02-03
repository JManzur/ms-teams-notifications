locals {
  metric_name        = "CPUUtilization" #https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html
  evaluation_periods = "1"
  period             = "60"
  threshold          = "50"
  statistic          = "Maximum" #Valid Values are: SampleCount, Average, Sum, Minimum, Maximum
}

resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization" {
  alarm_name          = lower("${var.name_prefix}-ec2-cpu-utilization")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = local.evaluation_periods
  metric_name         = local.metric_name
  namespace           = "AWS/EC2"
  period              = local.period
  statistic           = local.statistic
  threshold           = local.threshold
  treat_missing_data  = "missing" #missing, ignore, breaching, notBreaching. https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html
  alarm_description   = "Monitors EC2 ${var.instance_id} ${local.statistic} ${local.metric_name}. Alarm will trigger if ${local.metric_name} exceeds ${local.threshold}% during ${local.evaluation_periods} evaluation periods of ${local.period} seconds"

  dimensions = {
    InstanceId = var.instance_id
  }

  insufficient_data_actions = [aws_sns_topic.slack_notification.arn]
  ok_actions                = [aws_sns_topic.slack_notification.arn]
  alarm_actions             = [aws_sns_topic.slack_notification.arn]
}