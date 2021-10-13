resource "aws_cloudwatch_metric_alarm" "target_group_5xx_errors" {
  alarm_name          = "${aws_ecs_service.this.name}-target-group-5XX-errors"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  datapoints_to_alarm = 2
  evaluation_periods  = 5
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Average target group 500 error code count is too high"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [] # add sns email topic arn
  ok_actions          = [] # add sns email topic arn

  dimensions = {
    "TargetGroup"  = aws_alb_target_group.this.id
    "LoadBalancer" = aws_lb.this.id
  }

  tags = { env = var.env }
}

resource "aws_cloudwatch_metric_alarm" "lb_5xx_errors" {
  alarm_name          = "${aws_ecs_service.this.name}-load-balancer-5XX-errors"
  comparison_operator = "GreaterThanThreshold"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  datapoints_to_alarm = 2
  evaluation_periods  = 5
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "Average load balancer 500 error code count is too high"
  treat_missing_data  = "notBreaching"
  alarm_actions       = [] # add sns email topic arn
  ok_actions          = [] # add sns email topic arn

  dimensions = {
    "LoadBalancer" = aws_lb.this.id
  }

  tags = { env = var.env }
}
