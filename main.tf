# Maintenance Window
resource "aws_ssm_maintenance_window" "example" {
  name                        = var.name
  schedule                    = var.schedule
  cutoff                      = var.cutoff
  duration                    = var.duration
  description                 = var.description
  allow_unassociated_targets  = var.allow_unassociated_targets
  enabled                     = var.enabled
  end_date                    = var.end_date
  schedule_timezone           = var.schedule_timezone
  schedule_offset             = var.schedule_offset
  start_date                  = var.start_date
}

# Maintenance Window Target
resource "aws_ssm_maintenance_window_target" "example" {
  window_id     = aws_ssm_maintenance_window.example.id
  name          = var.name
  description   = var.description
  resource_type = var.resource_type
  targets       = var.targets
}

# Maintenance Window Task
resource "aws_ssm_maintenance_window_task" "example_task" {
  window_id              = aws_ssm_maintenance_window.example.id
  max_concurrency        = var.max_concurrency
  max_errors             = var.max_errors
  cutoff_behavior        = var.cutoff_behavior
  task_type              = var.task_type
  task_arn               = var.task_arn
  service_role_arn       = var.service_role_arn
  name                   = var.name
  description            = var.description
  priority               = var.priority
  targets                = var.targets
  task_invocation_parameters = var.task_invocation_parameters
}

# Patch Baseline
resource "aws_ssm_patch_baseline" "example" {
  name                              = var.name
  description                       = var.description
  operating_system                  = var.operating_system
  approval_rule                     = var.approval_rule
  approved_patches_compliance_level = var.approved_patches_compliance_level
  approved_patches_enable_non_security = var.approved_patches_enable_non_security
  approved_patches                  = var.approved_patches
  global_filter                     = var.global_filter
  rejected_patches_action           = var.rejected_patches_action
  rejected_patches                  = var.rejected_patches
  source                            = var.source
}

# Patch Group
resource "patch_group" "example" {
  baseline_id = aws_ssm_patch_baseline.example.id
  patch_group = var.patch_group
}
