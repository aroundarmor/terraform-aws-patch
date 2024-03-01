# Create S3 bucket
resource "aws_s3_bucket" "maintenance_window_bucket" {
  bucket = "ollion-maintenance-window-${var.account_id}-in-${var.region}"

}

####################################################################
####################################################################
# Create SNS topic
resource "aws_sns_topic" "example" {
  name = "example-topic"
}

# Create SNS topic policy allowing publish and subscribe for all principals
resource "aws_sns_topic_policy" "example" {
  arn    = aws_sns_topic.example.arn
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "ExampleTopicPolicy"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = [
        "SNS:Subscribe",
        "SNS:Publish",
        "SNS:Receive",
      ]
      Resource  = aws_sns_topic.example.arn
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
    slice(local.cron_parts, 0, 1),  // Minute
    [local.adjusted_hour],           // Adjusted hour
    slice(local.cron_parts, 2, 6)    // Remaining cron parts
  ))
}

####################################################################
####################################################################
# Create maintenance windows
resource "aws_ssm_maintenance_window" "example" {
  name                     = var.mw_name
  schedule                 = var.schedule
  cutoff                   = var.cutoff
  duration                 = var.duration
  description              = var.description
  allow_unassociated_targets = var.allow_unassociated_targets
  enabled                  = var.enabled
  end_date                 = var.end_date
  schedule_timezone        = var.schedule_timezone
  schedule_offset          = var.schedule_offset
  start_date               = var.start_date
}

####################################################################
####################################################################
# Create maintenance window targets
resource "aws_ssm_maintenance_window_target" "example" {
  window_id     = aws_ssm_maintenance_window.example.id
  resource_type = var.resource_type
  targets {
    key = "tag:${var.patch_group_tag}"
    values = var.patch_group_tag_value
  }
}

####################################################################
####################################################################
# Create maintenance window tasks
resource "aws_ssm_maintenance_window_task" "example_task" {
  window_id          = aws_ssm_maintenance_window.example.id
  max_concurrency    = var.max_concurrency
  max_errors         = var.max_errors
  cutoff_behavior    = var.cutoff_behavior
  task_type          = var.task_type
  task_arn           = var.task_arn
  service_role_arn   = var.service_role_arn
  priority           = var.priority
  targets {
    key = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.example[*].id
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name = "Operation"
        values = var.operation
      }
      parameter {
        name = "RebootOption"
        values = var.reboot_option
      }

      output_s3_bucket = aws_s3_bucket.maintenance_window_bucket.id
      output_s3_key_prefix = "/output_logs/${var.mw_name}"

      notification_config {
        notification_arn = aws_sns_topic.example.arn
        notification_events = ["Success", "Failed"]
        notification_type = "Command"

      }
      
      cloudwatch_config {
        cloudwatch_log_group_name = "aws/ssm/AWS-RunPatchBaseline-${var.mw_name}"
        cloudwatch_output_enabled = var.cloudwatch_output_enabled
      }
    }
  }
}

####################################################################
####################################################################
# Create patch baseline
resource "aws_ssm_patch_baseline" "example" {
  name                              = "Ollion-Patching-${var.operating_system}"
  description                       = "This is a patch baseline for tag:${var.patch_group_tag} in ${var.operating_system}"
  operating_system                  = var.operating_system
  approved_patches                  = var.approved_patches
  rejected_patches_action           = var.rejected_patches_action
  rejected_patches                  = var.rejected_patches

  approval_rule {
    approve_after_days = var.approve_after_days
    approve_until_date = var.approve_until_date
    compliance_level = var.compliance_level
    enable_non_security = var.enable_non_security
    patch_filter {
      key = "PRODUCT"
      values = var.patch_filter_product
    }
    patch_filter {
      key = "CLASSIFICATION"
      values = var.patch_filter_classification
    }
        patch_filter {
      key = "PRIORITY"
      values = var.patch_filter_priority
    }
        patch_filter {
      key = "SEVERITY"
      values = var.patch_filter_severity
    }
        patch_filter {
      key = "PRODUCT_FAMILY"
      values = var.patch_filter_product_family
    }
        patch_filter {
      key = "MSRC_SEVERITY"
      values = var.patch_filter_msrc_severity
    }
  }
}

####################################################################
####################################################################
# Create patch group
resource "patch_group" "example" {
  baseline_id = aws_ssm_patch_baseline.example.id
  patch_group = var.patch_group_tag_value  # Using maintenance window name as patch group name, adjust if needed
}

