resource "aws_ssm_maintenance_window" "production" {
  name                       = var.maintenance_window_name
  schedule                   = var.schedule_expression
  duration                   = var.duration_hours
  cutoff                     = var.cutoff_hours
  allow_unassociated_targets = true
  schedule_timezone          = "UTC"
  schedule_offset            = "+0000"
  start_date                 = var.start_date
  end_date                   = var.end_date
}

resource "aws_ssm_maintenance_window_target" "example_target" {
  window_id     = aws_ssm_maintenance_window.production.id
  resource_type = "INSTANCE"

  dynamic "targets" {
    for_each = var.target_tags
    content {
      key    = "tag:${targets.key}"
      values = [targets.value]
    }
  }
}

resource "aws_ssm_maintenance_window_task" "example_task" {
  window_id        = aws_ssm_maintenance_window.production.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"  # Patch Manager document ARN for patching
  priority         = 1  # Priority of the task
  max_concurrency  = 1  # Maximum number of targets that can run the task concurrently
  max_errors       = 1  # Maximum number of errors allowed before the task stops being executed
  service_role_arn = "arn:aws:iam::123456789012:role/service-role/AWS-SystemsManager-ServiceRole"

  task_invocation_parameters {
    run_command_parameters {
      document_version = "$LATEST"
      timeout_seconds  = 600  # Timeout for the patching command execution
    }
  }
}

resource "aws_ssm_patch_baseline" "example_baseline" {
  name             = var.patch_baseline_name
  operating_system = "WINDOWS"
  
  approval_rule {
    approve_after_days = var.approval_rule["approve_after_days"]
    compliance_level   = var.approval_rule["compliance_level"]
  }
}

resource "aws_ssm_patch_group" "example_patch_group" {
  baseline_id = aws_ssm_patch_baseline.example_baseline.id
  patch_group = var.patch_group_name
}
