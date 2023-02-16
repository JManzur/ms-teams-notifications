resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization" {
  alarm_name          = lower("${var.name_prefix}-ec2-cpu-utilization")
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum" #Valid Values are: SampleCount, Average, Sum, Minimum, Maximum
  threshold           = "80"
  alarm_description   = "This metric monitors the average CPU utilization of the EC2 instance with ID: ${var.instance_id}"

  dimensions = {
    InstanceId = var.instance_id
  }

  insufficient_data_actions = [aws_sns_topic.telegram_notification.arn]
  ok_actions                = [aws_sns_topic.telegram_notification.arn]
  alarm_actions             = [aws_sns_topic.telegram_notification.arn]
}