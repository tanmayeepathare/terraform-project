resource "aws_iam_role" "scheduler_role" {

  name = "${var.project_name}-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Principal = {
        Service = "scheduler.amazonaws.com"
      }

      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "${var.project_name}-scheduler-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "scheduler_policy" {

  name = "${var.project_name}-scheduler-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"

      Action = [
        "lambda:InvokeFunction"
      ]

      Resource = aws_lambda_function.scheduler.arn
    }]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler_attach" {

  role = aws_iam_role.scheduler_role.name

  policy_arn = aws_iam_policy.scheduler_policy.arn
}




#

resource "aws_scheduler_schedule" "stop_schedule" {

  name = "${var.project_name}-stop-schedule"

  group_name = "default"

  schedule_expression_timezone = "Asia/Calcutta"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "cron(47 21 * * ? *)"

  description = "Stop EC2 instances at night"

  target {

    arn = aws_lambda_function.scheduler.arn

    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      action = "stop"
    })

    retry_policy {
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 3
    }
  }
}

resource "aws_scheduler_schedule" "start_schedule" {

  name = "${var.project_name}-start-schedule"

  group_name = "default"

  schedule_expression_timezone = "Asia/Calcutta"

  flexible_time_window {
    mode = "OFF"
  }

 schedule_expression = "cron(50 0 * * ? *)"

  description = "Start EC2 instances in morning"

  target {

    arn = aws_lambda_function.scheduler.arn

    role_arn = aws_iam_role.scheduler_role.arn

    input = jsonencode({
      action = "start"
    })

    retry_policy {
      maximum_event_age_in_seconds = 300
      maximum_retry_attempts       = 3
    }
  }
}