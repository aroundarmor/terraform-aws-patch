
#common variables
variable "account_id" {
  description = "AWS account ID"
  type        = number
}

variable "region" {
  description = "AWS region"
  type        = string
}

# variable "adjusted_cron_expression" {
#   type = string
#   default = local.adjusted_cron_expression
# }

####################################################################
####################################################################
#variables for sns
variable "email_notification" {
  description = "Email address for notifications"
  type        = string
  default     = ""
}

####################################################################
####################################################################
#variable for maintenance window
variable "mw_name" {
  type        = string
  description = "The name of the maintenance window."
}

variable "schedule" {
  type        = string
  description = "The schedule of the Maintenance Window in the form of a cron or rate expression."
}

variable "cutoff" {
  type        = number
  description = "The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution."
  default     = 0
}

variable "duration" {
  type        = number
  description = "The duration of the Maintenance Window in hours."
  default     = 4
}

variable "allow_unassociated_targets" {
  type        = bool
  description = "Whether targets must be registered with the Maintenance Window before tasks can be defined for those targets."
  default     = false
}

variable "enabled" {
  type        = bool
  description = "Whether the maintenance window is enabled. Default: true."
  default     = true
}

variable "schedule_timezone" {
  type        = string
  description = "Timezone for schedule in Internet Assigned Numbers Authority (IANA) Time Zone Database format."
  default     = "UTC"
}

variable "schedule_offset" {
  type        = number
  description = "The number of days to wait after the date and time specified by a CRON expression before running the maintenance window."
  default     = null
}

variable "start_date" {
  type        = string
  description = "Timestamp in ISO-8601 extended format when to begin the maintenance window."
  default     = null
}

variable "end_date" {
  type        = string
  description = "Timestamp in ISO-8601 extended format when to no longer run the maintenance window."
  default     = null
}
####################################################################
####################################################################
#variables for maitenance window target

variable "resource_type" {
  type        = string
  description = "The type of target being registered with the Maintenance Window. Possible values are INSTANCE and RESOURCE_GROUP."
  default     = "INSTANCE"
}

variable "patch_group_tag" {
  type        = string
  description = "This value will be parsed to targets tag"
  default     = "PatchGroup"
}

variable "patch_group_tag_value" {
  type        = string
  description = "This value will be parsed to targets tag value"
  default     = "linux"
  validation {
    condition     = can(regex("^([a-z]+)$", var.patch_group_tag_value))
    error_message = "The value must be in lowercase"
  }
}


####################################################################
####################################################################
# variables for maitenance window tasks

variable "max_concurrency" {
  description = "The maximum number of targets this task can be run for in parallel."
  type        = number
  default     = 5
}

variable "max_errors" {
  description = "The maximum number of errors allowed before this task stops being scheduled."
  type        = number
  default     = 5
}

variable "cutoff_behavior" {
  description = "Indicates whether tasks should continue to run after the cutoff time specified in the maintenance windows is reached."
  #Valid values are CONTINUE_TASK and CANCEL_TASK.
  type    = string
  default = "CANCEL_TASK"
}

variable "task_type" {
  description = "The type of task being registered."
  type        = string
  default     = "RUN_COMMAND"
  # Add any validation rules if necessary
}

variable "task_arn" {
  description = "The ARN of the task to execute."
  type        = string
  default     = "AWS-RunPatchBaseline"
  # Add any validation rules if necessary
}

# variable "service_role_arn" {
#   description = "The role that should be assumed when executing the task."
#   type        = string
#   default     = "arn:aws:iam::${var.account_id}:role/OllionPatchingAutomation"
# }

variable "priority" {
  description = "The priority of the task in the Maintenance Window, the lower the number the higher the priority."
  type        = number
  default     = 1
}

variable "operation" {
  description = "This is used to configure type of operation to perform"
  # Possible values can be Scan/Install
  type    = list(string)
  default = ["Scan"]
}

variable "reboot_option" {
  description = "this is used to set reboot options in maitenance window task"
  # Possible values RebootIfNeeded | NoReboot
  type    = list(string)
  default = ["NoReboot"]
}

variable "cloudwatch_output_enabled" {
  description = "Enables Systems Manager to send command output to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "notification_events" {
  description = "The different events for which you can receive notifications"
  # Valid values: All, InProgress, Success, TimedOut, Cancelled, and Failed
  type    = string
  default = "All"
}

####################################################################
####################################################################
# variables for patch baseline
variable "operating_system" {
  description = "Operating system the patch baseline applies to."
  type        = string
  #Valid values are ALMA_LINUX, AMAZON_LINUX, AMAZON_LINUX_2, AMAZON_LINUX_2022, AMAZON_LINUX_2023, CENTOS, DEBIAN, MACOS, ORACLE_LINUX, RASPBIAN, REDHAT_ENTERPRISE_LINUX, ROCKY_LINUX, SUSE, UBUNTU, and WINDOWS
  default = "WINDOWS"
}

variable "approved_patches" {
  description = "List of explicitly approved patches for the baseline."
  type        = list(string)
  default     = []
}

variable "rejected_patches_action" {
  description = "Action for Patch Manager to take on patches included in the rejected_patches list."
  # Valid values are ALLOW_AS_DEPENDENCY and BLOCK.
  default = "BLOCK"
}

variable "rejected_patches" {
  description = "List of rejected patches."
  type        = list(string)
  default     = []
}

variable "approve_after_days" {
  description = "Number of days after the release date of each patch matched by the rule the patch is marked as approved in the patch baseline"
  #Valid Range: 0 to 100.
  #Conflicts with approve_until_date
  type    = number
  default = 7
}

variable "approve_until_date" {
  description = "Cutoff date for auto approval of released patches. Any patches released on or before this date are installed automatically"
  #Date is formatted as YYYY-MM-DD
  #Conflicts with approve_after_days
  type    = string
  default = null
}

variable "compliance_level" {
  description = "Compliance level for patches approved by this rule"
  #Valid values are CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, and UNSPECIFIED
  type    = string
  default = "UNSPECIFIED"
}

variable "enable_non_security" {
  description = "Boolean enabling the application of non-security updates"
  #Valid for Linux instances only.
  type    = bool
  default = false
}


variable "windows_patch_filter" {
  description = "Patch filter for Windows operating system"
  type        = map(list(string))
  default = {
    PRODUCT_FAMILY = ["WindowsServer2019", "WindowsServer2016"],
    CLASSIFICATION = ["CriticalUpdates", "SecurityUpdates"],
    MSRC_SEVERITY  = ["Critical", "Important"]
  }
}

variable "debian_patch_filter" {
  description = "Patch filter for Debian operating system"
  type        = map(list(string))
  default = {
    PRODUCT  = ["Debian"],
    PRIORITY = ["high"]
  }
}

variable "ubuntu_patch_filter" {
  description = "Patch filter for Ubuntu operating system"
  type        = map(list(string))
  default = {
    PRODUCT  = ["Ubuntu"],
    PRIORITY = ["high"]
  }
}

variable "macos_patch_filter" {
  description = "Patch filter for macOS operating system"
  type        = map(list(string))
  default = {
    PRODUCT        = ["macOS"],
    CLASSIFICATION = ["Critical", "Security"]
  }
}

variable "default_patch_filter" {
  description = "Patch filter for other operating systems"
  type        = map(list(string))
  default = {
    PRODUCT        = ["*"],
    CLASSIFICATION = ["Security"]
    SEVERITY       = ["Critical"]
  }
}


####################################################################
####################################################################
# Create scheduler variables
variable "start_instance" {
  description = "Specifies whether the schedule is enabled or disabled."
  # One of: ENABLED (default), DISABLED.
  type    = string
  default = "ENABLED"
}

####################################################################
####################################################################
# Create variables for start lambda function
variable "lambda_start_name" {
  description = "This will reference the name of lambda that starts the stopped instances"
  type        = string
  default     = "ollion-start-function"
}

# additional variable
# variables.tf
