maintenance_window = {
  test-1 = {
    mw_name                    = "test-1"
    enabled                    = true
    account_id                 = 211125340848
    region                     = "us-east-1"
    email_notification         = "example@example.com"
    schedule                   = "cron(30 12 ? * WED *)"
    schedule_start             = "cron(30 11 ? * WED *)"
    duration                   = 4
    allow_unassociated_targets = "true"
    schedule_timezone          = "Asia/Kolkata"
    patch_group_tag_value      = "windows"
    operation                  = ["Scan"]
    reboot_option              = ["NoReboot"]
    operating_system           = "WINDOWS"
    windows_patch_filter = {
      CLASSIFICATION = ["CriticalUpdates", "SecurityUpdates"]
      PRODUCT_FAMILY = ["WINDOWS"]
      MSRC_SEVERITY  = ["Critical", "Important"]
    }
    approved_patches    = []
    rejected_patches    = []
    compliance_level    = "HIGH"
    enable_non_security = false
    approve_after_days  = 7
    start_instance      = "ENABLED"
    debian_patch_filter = {
        PRODUCT  = [""],
        PRIORITY = [""]
    }
    end_date = null
    macos_patch_filter = {
        PRODUCT        = ["macOS"],
        CLASSIFICATION = ["Critical", "Security"]        
    }
    default_patch_filter = {
      PRODUCT        = [""]
      CLASSIFICATION = [""]
      SEVERITY       = [""]
    }
    # cloudwatch_output_enabled = null
    # cutoff = null
    # cutoff_behavior = null
    # max_concurrency = null
    # max_errors = null
    # notification_events = null
    # priority = null
    # rejected_patches_action = null
    # resource_type = null
    # schedule_offset = null
    # start_date = null
    # task_arn = null
    # task_type = null
  }
  test-2 = {
    mw_name                    = "test-2"
    enabled                    = false
    account_id                 = 211125340848
    region                     = "us-east-1"
    email_notification         = "sourav.patel@ollion.com"
    schedule                   = "cron(30 1 ? * WED *)"
    schedule_start             = "cron(30 00? * WED *)"
    duration                   = 5
    allow_unassociated_targets = "false"
    schedule_timezone          = "Asia/Istanbul"
    patch_group_tag_value      = "linux"
    operation                  = ["Install"]
    reboot_option              = ["RebootIfRequired"]
    operating_system           = "AMAZON_LINUX_2023"
    default_patch_filter = {
      PRODUCT        = ["*"]
      CLASSIFICATION = ["Security"]
      SEVERITY       = ["Critical"]
    }
    approved_patches    = []
    rejected_patches    = []
    compliance_level    = "LOW"
    enable_non_security = false
    approve_after_days  = 14
    start_instance      = "DISABLED"
    debian_patch_filter = {
        PRODUCT  = [""],
        PRIORITY = [""]
    }
    macos_patch_filter = {
        PRODUCT        = [""],
        CLASSIFICATION = ["", ""]        
    }
    windows_patch_filter = {
      CLASSIFICATION = [""]
      PRODUCT_FAMILY = [""]
      MSRC_SEVERITY  = [""]
    }
    # cloudwatch_output_enabled = null
    # cutoff = null
    # cutoff_behavior = null
    # end_date = null
    # max_concurrency = null
    # max_errors = null
    # notification_events = null
    # patch_group_tag = null
    # priority = null
    # rejected_patches_action = null
    # resource_type = null
    # schedule_offset = null
    # start_date = null
    # task_arn = null
    # task_type = null
  }
  test3 = {
    mw_name                    = "test3"
    enabled                    = true
    account_id                 = 211125340848
    region                     = "us-east-1"
    email_notification         = "dummy@gmail.com"
    schedule                   = "cron(30 5 ? * WED *)"
    schedule_start             = "cron(30 04? * WED *)"
    duration                   = 2
    allow_unassociated_targets = "true"
    schedule_timezone          = "Asia/Istanbul"
    patch_group_tag_value      = "dummy"
    operation                  = ["Scan"]
    reboot_option              = ["NoReboot"]
    operating_system           = "DEBIAN"
    debian_patch_filter = {
      PRODUCT  = ["*"]
      PRIORITY = ["*"]
    }
    approved_patches    = []
    rejected_patches    = []
    compliance_level    = "LOW"
    enable_non_security = false
    approve_after_days  = 2
    start_instance      = "ENABLED"
    default_patch_filter = {
      PRODUCT        = [""]
      CLASSIFICATION = [""]
      SEVERITY       = [""]
    }
    macos_patch_filter = {
        PRODUCT        = [""],
        CLASSIFICATION = ["", ""]        
    }
    windows_patch_filter = {
      CLASSIFICATION = [""]
      PRODUCT_FAMILY = [""]
      MSRC_SEVERITY  = [""]
    }
    # cloudwatch_output_enabled = null
    # cutoff = null
    # cutoff_behavior = null
    # end_date = null
    # max_concurrency = null
    # max_errors = null
    # notification_events = null
    # patch_group_tag = null
    # priority = null
    # rejected_patches_action = null
    # resource_type = null
    # schedule_offset = null
    # start_date = null
    # task_arn = null
    # task_type = null
  }
}
