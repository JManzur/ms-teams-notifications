resource "aws_cloudwatch_metric_alarm" "ec2_cpu_utilization" {
  alarm_name          = "ec2-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric checks the average CPU utilization of an EC2 instance"

  dimensions = {
    InstanceId = var.instance_id
  }

  insufficient_data_actions = [aws_sns_topic.ms_teams_notification.arn]
  ok_actions                = [aws_sns_topic.ms_teams_notification.arn]
  alarm_actions             = [aws_sns_topic.ms_teams_notification.arn]
}