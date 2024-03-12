
# Create S3 bucket
resource "aws_s3_bucket" "maintenance_window_bucket" {
  bucket = "ollion-maintenance-window-${var.mw_name}-in-${var.region}"

}

####################################################################
####################################################################
# Create SNS topic
resource "aws_sns_topic" "example" {
  name = "ollion-patch-${aws_ssm_maintenance_window.example.id}"
}

# Create SNS topic policy allowing publish and subscribe for all principals
resource "aws_sns_topic_policy" "example" {
  arn = aws_sns_topic.example.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ExampleTopicPolicy"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action = [
        "SNS:Subscribe",
        "SNS:Publish",
        "SNS:Receive",
      ]
      Resource = aws_sns_topic.example.arn
    }]
  })
}

# Subscribe email to SNS topic

resource "aws_sns_topic_subscription" "example" {
  topic_arn = aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = var.email_notification
}

# Include necessary providers
####################################################################
####################################################################
# Create cron manipulator for start instance
# Parsing the cron expression
locals {
  cron_parts = split(" ", var.schedule)
}

# Adjusting the hour value
locals {
  adjusted_hour = (tonumber(local.cron_parts[1]) - 1) % 24
}

# Reconstructing the cron expression with the adjusted hour value
locals {
  adjusted_cron_expression = join(" ", concat(
    slice(local.cron_parts, 0, 1), // Minute
    [local.adjusted_hour],         // Adjusted hour
    slice(local.cron_parts, 2, 6)  // Remaining cron parts
  ))
}

# output "adjusted_cron_expression" {
#   value = local.adjusted_cron_expression
# }
####################################################################
####################################################################
# Create Cloudwatch Log group
resource "aws_cloudwatch_log_group" "example" {
  name              = "ssm/aws/AWS-RunPatchBaseline-${var.mw_name}"
  retention_in_days = 60  # Set the desired retention period for logs, in days
}


####################################################################
####################################################################
# Create maintenance windows
resource "aws_ssm_maintenance_window" "example" {
  name                       = var.mw_name
  schedule                   = var.schedule
  cutoff                     = var.cutoff
  duration                   = var.duration
  allow_unassociated_targets = var.allow_unassociated_targets
  enabled                    = var.enabled
  end_date                   = var.end_date
  schedule_timezone          = var.schedule_timezone
  schedule_offset            = var.schedule_offset
  start_date                 = var.start_date
}

####################################################################
####################################################################
# Create maintenance window targets
resource "aws_ssm_maintenance_window_target" "example" {
  window_id     = aws_ssm_maintenance_window.example.id
  resource_type = var.resource_type
  targets {
    key    = "tag:${var.patch_group_tag}"
    values = [var.patch_group_tag_value]
  }
}

####################################################################
####################################################################
# Create maintenance window tasks
resource "aws_ssm_maintenance_window_task" "example_task" {
  window_id        = aws_ssm_maintenance_window.example.id
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors
  cutoff_behavior  = var.cutoff_behavior
  task_type        = var.task_type
  task_arn         = var.task_arn
#  service_role_arn = "arn:aws:iam::${var.account_id}:role/OllionPatchingAutomation"
  service_role_arn = "arn:aws:iam::${var.account_id}:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  priority         = var.priority
  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.example[*].id
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = var.operation
      }
      parameter {
        name   = "RebootOption"
        values = var.reboot_option
      }

      output_s3_bucket     = aws_s3_bucket.maintenance_window_bucket.id
      output_s3_key_prefix = "/output_logs/${var.mw_name}"
      service_role_arn = "arn:aws:iam::${var.account_id}:role/OllionPatchingAutomation"

      notification_config {
        notification_arn    = aws_sns_topic.example.arn
        notification_events = ["Success"]
        notification_type   = "Command"

      }

      cloudwatch_config {
        cloudwatch_log_group_name = aws_cloudwatch_log_group.example.name
        cloudwatch_output_enabled = var.cloudwatch_output_enabled
      }
    }
  }
}

####################################################################
####################################################################
# Create patch baseline
resource "aws_ssm_patch_baseline" "example" {
  name                    = "Ollion-Patching-${var.operating_system}"
  description             = "This is a patch baseline for tag:${var.patch_group_tag} in ${var.operating_system}"
  operating_system        = var.operating_system
  approved_patches        = var.approved_patches
  rejected_patches_action = var.rejected_patches_action
  rejected_patches        = var.rejected_patches

  dynamic "approval_rule" {
    for_each = var.operating_system == "WINDOWS" ? [1] : []

    content {
      approve_after_days  = var.approve_after_days
      approve_until_date  = var.approve_until_date
      compliance_level    = var.compliance_level
      enable_non_security = var.enable_non_security

      dynamic "patch_filter" {
        for_each = var.windows_patch_filter

        content {
          key    = patch_filter.key
          values = patch_filter.value
        }
      }
    }
  }

  dynamic "approval_rule" {
    for_each = var.operating_system == "DEBIAN" || var.operating_system == "UBUNTU" ? [1] : []

    content {
      approve_after_days  = var.approve_after_days
      approve_until_date  = var.approve_until_date
      compliance_level    = var.compliance_level
      enable_non_security = var.enable_non_security

      dynamic "patch_filter" {
        for_each = var.debian_patch_filter

        content {
          key    = patch_filter.key
          values = patch_filter.value
        }
      }
    }
  }

  dynamic "approval_rule" {
    for_each = var.operating_system == "MACOS" ? [1] : []

    content {
      approve_after_days  = var.approve_after_days
      approve_until_date  = var.approve_until_date
      compliance_level    = var.compliance_level
      enable_non_security = var.enable_non_security

      dynamic "patch_filter" {
        for_each = var.macos_patch_filter

        content {
          key    = patch_filter.key
          values = patch_filter.value
        }
      }
    }
  }

  dynamic "approval_rule" {
    for_each = var.operating_system != "WINDOWS" && var.operating_system != "DEBIAN" && var.operating_system != "UBUNTU" && var.operating_system != "MACOS" ? [1] : []

    content {
      approve_after_days  = var.approve_after_days
      approve_until_date  = var.approve_until_date
      compliance_level    = var.compliance_level
      enable_non_security = var.enable_non_security

      dynamic "patch_filter" {
        for_each = var.default_patch_filter

        content {
          key    = patch_filter.key
          values = patch_filter.value
        }
      }
    }
  }
}


####################################################################
####################################################################
# Create patch group
resource "aws_ssm_patch_group" "example" {
  baseline_id = aws_ssm_patch_baseline.example.id
  patch_group = var.patch_group_tag_value # Using maintenance window name as patch group name, adjust if needed
}

####################################################################
####################################################################
#lambda to start

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role_${aws_ssm_maintenance_window.example.id}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy_${aws_ssm_maintenance_window.example.id}"
  description = "Policy for Lambda function"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:${var.region}:${var.account_id}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${aws_lambda_function.lambda_start_function.function_name}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:StartInstances",
          "ec2:DescribeTags",
          "ec2:CreateTags"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_role.name
}

resource "aws_cloudwatch_log_group" "lambda_start" {
  name              = "/aws/lambda/lambda-start-${aws_ssm_maintenance_window.example.id}"
  retention_in_days = 14
}

resource "aws_lambda_function" "lambda_start_function" {
  function_name = "lambda-start-${aws_ssm_maintenance_window.example.id}"
  architectures = ["x86_64"]
  package_type  = "Zip"
  filename      = "start_function_payload.zip"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 15
  memory_size   = 128
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_start.name
  }
}

####################################################################
####################################################################
#lambda to stop

resource "aws_iam_role" "lambda_stop_role" {
  name = "stop_execution_role_${aws_ssm_maintenance_window.example.id}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_stop_policy" {
  name        = "lambda_stop_policy_${aws_ssm_maintenance_window.example.id}"
  description = "Policy for Lambda function"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "logs:CreateLogGroup",
        "Resource" : "arn:aws:logs:${var.region}:${var.account_id}:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/lambda/${aws_lambda_function.lambda_stop_function.function_name}:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:StopInstances",
          "ec2:DescribeTags",
          "ec2:DeleteTags"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_stop_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_stop_policy.arn
  role       = aws_iam_role.lambda_stop_role.name
}

resource "aws_cloudwatch_log_group" "lambda_stop" {
  name              = "/aws/lambda/lambda-stop-${aws_ssm_maintenance_window.example.id}"
  retention_in_days = 14
}

resource "aws_lambda_function" "lambda_stop_function" {
  function_name = "lambda-stop-${aws_ssm_maintenance_window.example.id}"
  architectures = ["x86_64"]
  package_type  = "Zip"
  filename      = "stop_function_payload.zip"
  role          = aws_iam_role.lambda_stop_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 15
  memory_size   = 128
  ephemeral_storage {
    size = 512
  }
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_stop.name
  }
}




####################################################################
####################################################################
# Create Role for start schedulers
resource "aws_iam_role" "scheduler_role" {
  name = "scheduler_execution_role-${aws_ssm_maintenance_window.example.id}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "scheduler.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : [var.account_id]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "scheduler_policy" {
  name        = "scheduler_policy_${aws_ssm_maintenance_window.example.id}"
  description = "Policy for AWS Scheduler execution"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "lambda:InvokeFunction",
        "Resource" : [
          "${aws_lambda_function.lambda_start_function.arn}:*",
          "${aws_lambda_function.lambda_start_function.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler_policy_attachment" {
  role       = aws_iam_role.scheduler_role.name
  policy_arn = aws_iam_policy.scheduler_policy.arn
}

# Create aws_schedule_scheduler


resource "aws_scheduler_schedule" "start" {
  state      = var.start_instance
  name       = "ollion-start-${aws_ssm_maintenance_window.example.id}"
  group_name = "default"

  flexible_time_window {
    mode                      = "FLEXIBLE"
    maximum_window_in_minutes = 30
  }

  # schedule_expression          = local.adjusted_cron_expression
  schedule_expression          = var.schedule_start
  schedule_expression_timezone = var.schedule_timezone


  target {
    arn      = aws_lambda_function.lambda_start_function.arn
    role_arn = aws_iam_role.scheduler_role.arn
    input = jsonencode({
      "patchgroup_values" : [var.patch_group_tag_value]
    })
  }
  depends_on = [aws_lambda_function.lambda_start_function, aws_iam_role.scheduler_role]
}


####################################################################
####################################################################
# Create stop functionality
resource "aws_iam_role" "scheduler_stop_role" {
  name = "scheduler_stop_execution_role-${aws_ssm_maintenance_window.example.id}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "scheduler.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceAccount" : [var.account_id]
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "scheduler_stop_policy" {
  name        = "scheduler_stop_policy_${aws_ssm_maintenance_window.example.id}"
  description = "Policy for AWS Scheduler execution"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "lambda:InvokeFunction",
        "Resource" : [
          "${aws_lambda_function.lambda_stop_function.arn}:*",
          "${aws_lambda_function.lambda_stop_function.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "scheduler_stop_policy_attachment" {
  role       = aws_iam_role.scheduler_stop_role.name
  policy_arn = aws_iam_policy.scheduler_stop_policy.arn
}

# Create aws_schedule_scheduler


resource "aws_scheduler_schedule" "stop" {
  state      = var.stop_instance
  name       = "ollion-stop-${aws_ssm_maintenance_window.example.id}"
  group_name = "default"

  flexible_time_window {
    mode                      = "OFF"
    # maximum_window_in_minutes = 30
  }

  # schedule_expression          = local.adjusted_cron_expression
  schedule_expression          = var.schedule_stop
  schedule_expression_timezone = var.schedule_timezone


  target {
    arn      = aws_lambda_function.lambda_stop_function.arn
    role_arn = aws_iam_role.scheduler_stop_role.arn
    input = jsonencode({
      "patchgroup_values" : [var.patch_group_tag_value]
    })
  }
  depends_on = [aws_lambda_function.lambda_stop_function, aws_iam_role.scheduler_stop_role]
}
