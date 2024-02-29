variable "name" {
  description = "The name of the maintenance window or patch baseline."
  type        = string
}

variable "schedule" {
  description = "The schedule of the maintenance window, in cron or rate format."
  type        = string
}

variable "cutoff" {
  description = "The number of hours before the end of the maintenance window that Systems Manager stops scheduling new tasks for execution."
  type        = string
}

variable "duration" {
  description = "The duration of the maintenance window in hours."
  type        = string
}

variable "description" {
  description = "The description of the maintenance window or patch baseline."
  type        = string
}

variable "allow_unassociated_targets" {
  description = "Whether to allow unassociated targets in the maintenance window."
  type        = bool
}

variable "enabled" {
  description = "Whether the maintenance window is enabled."
  type        = bool
}

variable "end_date" {
  description = "The end date of the maintenance window."
  type        = string
}

variable "schedule_timezone" {
  description = "The timezone for the maintenance window schedule."
  type        = string
}

variable "schedule_offset" {
  description = "The number of days to wait to run maintenance window tasks after the schedule cron expression date."
  type        = string
}

variable "start_date" {
  description = "The start date of the maintenance window."
  type        = string
}

variable "window_id" {
  description = "The ID of the maintenance window."
  type        = string
}

variable "resource_type" {
  description = "The type of the target resource for the maintenance window."
  type        = string
}

variable "targets" {
  description = "The list of targets for the maintenance window."
  type        = list(string)
}

variable "max_concurrency" {
  description = "The maximum number of tasks allowed to run concurrently during the maintenance window."
  type        = string
}

variable "max_errors" {
  description = "The maximum number of errors allowed before the task stops being scheduled."
  type        = string
}

variable "cutoff_behavior" {
  description = "The behavior of the maintenance window when tasks exceed the cutoff time."
  type        = string
}

variable "task_type" {
  description = "The type of task to run in the maintenance window."
  type        = string
}

variable "task_arn" {
  description = "The ARN of the task to run in the maintenance window."
  type        = string
}

variable "service_role_arn" {
  description = "The ARN of the service role for Systems Manager to assume when running maintenance window tasks."
  type        = string
}

variable "priority" {
  description = "The priority of the maintenance window task in relation to other tasks in the window."
  type        = string
}

variable "task_invocation_parameters" {
  description = "The parameters for task invocation in the maintenance window."
  type = object({
    automation_parameters = object({
      document_version = string
      parameter        = map(string)
    })
    lambda_parameters = object({
      client_context = string
      payload        = string
      qualifier      = string
    })
    run_command_parameters = object({
      comment           = string
      document_hash     = string
      document_hash_type= string
      notification_config = object({
        notification_arn    = string
        notification_events = list(string)
        notification_type   = string
      })
      output_s3_bucket     = string
      output_s3_key_prefix = string
      service_role_arn     = string
      timeout_seconds      = number
      cloudwatch_config = object({
        cloudwatch_log_group_name = string
        cloudwatch_output_enabled = bool
      })
    })
    step_functions_parameters = object({
      input = string
      name  = string
    })
  })
}

variable "operating_system" {
  description = "The operating system for the patch baseline."
  type        = string
}

variable "approval_rule" {
  description = "The rule used to approve patches for the patch baseline."
  type        = list(string)
}

variable "approved_patches_compliance_level" {
  description = "The compliance level for approved patches in the patch baseline."
  type        = string
}

variable "approved_patches_enable_non_security" {
  description = "Whether non-security patches are included in the list of approved patches for the patch baseline."
  type        = bool
}

variable "approved_patches" {
  description = "The list of approved patches for the patch baseline."
  type        = list(string)
}

variable "global_filter" {
  description = "The global filter for the patch baseline."
  type = object({
    patch_filters = list(object({
      key   = string
      values = list(string)
    }))
  })
}

variable "rejected_patches_action" {
  description = "The action for rejected patches in the patch baseline."
  type        = string
}

variable "rejected_patches" {
  description = "The list of rejected patches for the patch baseline."
  type        = list(string)
}

variable "source" {
  description = "The source for the patch baseline."
  type        = string
}

variable "baseline_id" {
  description = "The ID of the patch baseline."
  type        = string
}

variable "patch_group" {
  description = "The patch group for the patch baseline."
  type        = string
}
