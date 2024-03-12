<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.lambda_start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.lambda_stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.lambda_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.lambda_stop_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.scheduler_stop_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_stop_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.scheduler_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.scheduler_stop_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_stop_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduler_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.scheduler_stop_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.lambda_start_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.lambda_stop_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket.maintenance_window_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_scheduler_schedule.start](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_scheduler_schedule.stop](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/scheduler_schedule) | resource |
| [aws_sns_topic.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_sns_topic_subscription.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_subscription) | resource |
| [aws_ssm_maintenance_window.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window) | resource |
| [aws_ssm_maintenance_window_target.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_target) | resource |
| [aws_ssm_maintenance_window_task.example_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_task) | resource |
| [aws_ssm_patch_baseline.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_baseline) | resource |
| [aws_ssm_patch_group.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_patch_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID | `number` | n/a | yes |
| <a name="input_allow_unassociated_targets"></a> [allow\_unassociated\_targets](#input\_allow\_unassociated\_targets) | Whether targets must be registered with the Maintenance Window before tasks can be defined for those targets. | `bool` | `false` | no |
| <a name="input_approve_after_days"></a> [approve\_after\_days](#input\_approve\_after\_days) | Number of days after the release date of each patch matched by the rule the patch is marked as approved in the patch baseline. Conflicts with approve\_until\_date. Valid Range: 0 to 100. | `number` | `7` | no |
| <a name="input_approve_until_date"></a> [approve\_until\_date](#input\_approve\_until\_date) | Cutoff date for auto approval of released patches. Any patches released on or before this date are installed automatically. Date is formatted as YYYY-MM-DD. Conflicts with approve\_after\_days | `string` | `null` | no |
| <a name="input_approved_patches"></a> [approved\_patches](#input\_approved\_patches) | List of explicitly approved patches for the baseline. | `list(string)` | `[]` | no |
| <a name="input_cloudwatch_output_enabled"></a> [cloudwatch\_output\_enabled](#input\_cloudwatch\_output\_enabled) | Enables Systems Manager to send command output to CloudWatch Logs | `bool` | `true` | no |
| <a name="input_compliance_level"></a> [compliance\_level](#input\_compliance\_level) | Compliance level for patches approved by this rule. Valid values are CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, and UNSPECIFIED | `string` | `"UNSPECIFIED"` | no |
| <a name="input_cutoff"></a> [cutoff](#input\_cutoff) | The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution. | `number` | `0` | no |
| <a name="input_cutoff_behavior"></a> [cutoff\_behavior](#input\_cutoff\_behavior) | Indicates whether tasks should continue to run after the cutoff time specified in the maintenance windows is reached. Valid values are CONTINUE\_TASK and CANCEL\_TASK. | `string` | `"CANCEL_TASK"` | no |
| <a name="input_debian_patch_filter"></a> [debian\_patch\_filter](#input\_debian\_patch\_filter) | Patch filter for Debian operating system | `map(list(string))` | <pre>{<br>  "PRIORITY": [<br>    "high"<br>  ],<br>  "PRODUCT": [<br>    "Debian"<br>  ]<br>}</pre> | no |
| <a name="input_default_patch_filter"></a> [default\_patch\_filter](#input\_default\_patch\_filter) | Patch filter for other operating systems | `map(list(string))` | <pre>{<br>  "CLASSIFICATION": [<br>    "Security"<br>  ],<br>  "PRODUCT": [<br>    "*"<br>  ],<br>  "SEVERITY": [<br>    "Critical"<br>  ]<br>}</pre> | no |
| <a name="input_duration"></a> [duration](#input\_duration) | The duration of the Maintenance Window in hours. | `number` | `4` | no |
| <a name="input_email_notification"></a> [email\_notification](#input\_email\_notification) | Email address for notifications | `string` | `""` | no |
| <a name="input_enable_non_security"></a> [enable\_non\_security](#input\_enable\_non\_security) | Boolean enabling the application of non-security updates. Valid for Linux instances only. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the maintenance window is enabled. Default: true. | `bool` | `true` | no |
| <a name="input_end_date"></a> [end\_date](#input\_end\_date) | Timestamp in ISO-8601 extended format when to no longer run the maintenance window. | `string` | `null` | no |
| <a name="input_macos_patch_filter"></a> [macos\_patch\_filter](#input\_macos\_patch\_filter) | Patch filter for macOS operating system | `map(list(string))` | <pre>{<br>  "CLASSIFICATION": [<br>    "Critical",<br>    "Security"<br>  ],<br>  "PRODUCT": [<br>    "macOS"<br>  ]<br>}</pre> | no |
| <a name="input_max_concurrency"></a> [max\_concurrency](#input\_max\_concurrency) | The maximum number of targets this task can be run for in parallel. | `number` | `5` | no |
| <a name="input_max_errors"></a> [max\_errors](#input\_max\_errors) | The maximum number of errors allowed before this task stops being scheduled. | `number` | `5` | no |
| <a name="input_mw_name"></a> [mw\_name](#input\_mw\_name) | The name of the maintenance window. | `string` | n/a | yes |
| <a name="input_notification_events"></a> [notification\_events](#input\_notification\_events) | The different events for which you can receive notifications. Valid values: All, InProgress, Success, TimedOut, Cancelled, and Failed | `string` | `"All"` | no |
| <a name="input_operating_system"></a> [operating\_system](#input\_operating\_system) | Operating system the patch baseline applies to. Valid values are ALMA\_LINUX, AMAZON\_LINUX, AMAZON\_LINUX\_2, AMAZON\_LINUX\_2022, AMAZON\_LINUX\_2023, CENTOS, DEBIAN, MACOS, ORACLE\_LINUX, RASPBIAN, REDHAT\_ENTERPRISE\_LINUX, ROCKY\_LINUX, SUSE, UBUNTU, and WINDOWS | `string` | `"WINDOWS"` | no |
| <a name="input_operation"></a> [operation](#input\_operation) | This is used to configure type of operation to perform. Possible values can be Scan/Install | `list(string)` | <pre>[<br>  "Scan"<br>]</pre> | no |
| <a name="input_patch_group_tag"></a> [patch\_group\_tag](#input\_patch\_group\_tag) | This value will be parsed to targets tag | `string` | `"PatchGroup"` | no |
| <a name="input_patch_group_tag_value"></a> [patch\_group\_tag\_value](#input\_patch\_group\_tag\_value) | This value will be parsed to targets tag value | `string` | `"linux"` | no |
| <a name="input_priority"></a> [priority](#input\_priority) | The priority of the task in the Maintenance Window, the lower the number the higher the priority. | `number` | `1` | no |
| <a name="input_reboot_option"></a> [reboot\_option](#input\_reboot\_option) | This is used to set reboot options in maitenance window task. Possible values RebootIfNeeded \| NoReboot | `list(string)` | <pre>[<br>  "NoReboot"<br>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_rejected_patches"></a> [rejected\_patches](#input\_rejected\_patches) | List of rejected patches. | `list(string)` | `[]` | no |
| <a name="input_rejected_patches_action"></a> [rejected\_patches\_action](#input\_rejected\_patches\_action) | Action for Patch Manager to take on patches included in the rejected\_patches list. Valid values are ALLOW\_AS\_DEPENDENCY and BLOCK. | `string` | `"BLOCK"` | no |
| <a name="input_resource_type"></a> [resource\_type](#input\_resource\_type) | The type of target being registered with the Maintenance Window. Possible values are INSTANCE and RESOURCE\_GROUP. | `string` | `"INSTANCE"` | no |
| <a name="input_schedule"></a> [schedule](#input\_schedule) | The schedule of the Maintenance Window in the form of a cron or rate expression. | `string` | n/a | yes |
| <a name="input_schedule_offset"></a> [schedule\_offset](#input\_schedule\_offset) | The number of days to wait after the date and time specified by a CRON expression before running the maintenance window. | `number` | `null` | no |
| <a name="input_schedule_start"></a> [schedule\_start](#input\_schedule\_start) | This value will be fed to start scheduler and will be used to start the servers before running Scan/Install operations | `string` | n/a | yes |
| <a name="input_schedule_stop"></a> [schedule\_stop](#input\_schedule\_stop) | This value will be fed to start scheduler and will be used to start the servers before running Scan/Install operations | `string` | n/a | yes |
| <a name="input_schedule_timezone"></a> [schedule\_timezone](#input\_schedule\_timezone) | Timezone for schedule in Internet Assigned Numbers Authority (IANA) Time Zone Database format. | `string` | `"UTC"` | no |
| <a name="input_start_date"></a> [start\_date](#input\_start\_date) | Timestamp in ISO-8601 extended format when to begin the maintenance window. | `string` | `null` | no |
| <a name="input_start_instance"></a> [start\_instance](#input\_start\_instance) | Specifies whether the schedule is enabled or disabled. One of: ENABLED (default), DISABLED. | `string` | `"ENABLED"` | no |
| <a name="input_stop_instance"></a> [stop\_instance](#input\_stop\_instance) | Specifies whether the schedule is enabled or disabled. One of: ENABLED (default), DISABLED. | `string` | `"ENABLED"` | no |
| <a name="input_task_arn"></a> [task\_arn](#input\_task\_arn) | The ARN of the task to execute. | `string` | `"AWS-RunPatchBaseline"` | no |
| <a name="input_task_type"></a> [task\_type](#input\_task\_type) | The type of task being registered. | `string` | `"RUN_COMMAND"` | no |
| <a name="input_ubuntu_patch_filter"></a> [ubuntu\_patch\_filter](#input\_ubuntu\_patch\_filter) | Patch filter for Ubuntu operating system | `map(list(string))` | <pre>{<br>  "PRIORITY": [<br>    "high"<br>  ],<br>  "PRODUCT": [<br>    "Ubuntu"<br>  ]<br>}</pre> | no |
| <a name="input_windows_patch_filter"></a> [windows\_patch\_filter](#input\_windows\_patch\_filter) | Patch filter for Windows operating system | `map(list(string))` | <pre>{<br>  "CLASSIFICATION": [<br>    "CriticalUpdates",<br>    "SecurityUpdates"<br>  ],<br>  "MSRC_SEVERITY": [<br>    "Critical",<br>    "Important"<br>  ],<br>  "PRODUCT": [<br>    "WindowsServer2019",<br>    "WindowsServer2016"<br>  ]<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adjusted_cron_expression"></a> [adjusted\_cron\_expression](#output\_adjusted\_cron\_expression) | n/a |
<!-- END_TF_DOCS -->
