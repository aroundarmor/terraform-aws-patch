# Common Variables
name = "ServerPatchScan"
schedule = "cron(0 2 ? * SUN *)"  # Example: Run every Sunday at 2:00 AM UTC
cutoff = "1"
duration = "2"
description = "Weekly server patch scan"
allow_unassociated_targets = true
enabled = true
start_date = "2024-03-01"
end_date = "2025-03-01"
schedule_timezone = "UTC"
schedule_offset = "1"
max_concurrency = "1"
max_errors = "1"
cutoff_behavior = "Continue"
service_role_arn = "arn:aws:iam::123456789012:role/service-role/AmazonSSMMaintenanceWindowRole"

# Maintenance Window Target
window_id = "<maintenance_window_id>"
name = "ServerScanTarget"
description = "Target server for patch scan"
resource_type = "INSTANCE_ID"  # Assuming you want to target an EC2 instance
targets = ["i-1234567890abcdef0"]  # Replace with the ID of your EC2 instance

# Maintenance Window Task Invocation Parameters
task_invocation_parameters = {
  run_command_parameters = {
    comment = "Scan for missing patches"
    notification_config = {
      notification_arn = "arn:aws:sns:us-west-2:123456789012:MyTopic"
      notification_events = ["Success", "Failure"]
      notification_type = "Command"
    }
    output_s3_bucket = "my-bucket"
    output_s3_key_prefix = "patch-scan-results/"
    service_role_arn = "arn:aws:iam::123456789012:role/service-role/AmazonSSMRunPatchBaselineRole"
    timeout_seconds = 600  # 10 minutes
    cloudwatch_config = {
      cloudwatch_log_group_name = "/aws/ssm/patch-scan-logs"
      cloudwatch_output_enabled = true
    }
  }
}

# Patch Baseline
operating_system = "WINDOWS"
approval_rule = ["OPTIONAL"]
approved_patches_compliance_level = "CRITICAL"
approved_patches_enable_non_security = false
approved_patches = []
global_filter = {
  patch_filters = [
    {
      key = "MSRC_SEVERITY"
      values = ["Critical"]
    }
  ]
}
rejected_patches_action = "BLOCK"
rejected_patches = []
source = "MICROSOFT"

# Patch Group
baseline_id = "<patch_baseline_id>"
patch_group = "WindowsServers"

