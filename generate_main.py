import csv
import sys

def generate_module(region):
    module_template = """
module "patch_deployment_{alias}" {{
  source = "./modules/patch-deploy"
  for_each = {{
    for key, value in var.maintenance_window : key => value if value.region == "{region}"
  }}
  providers = {{
    aws = aws.{alias}
  }}

  account_id                 = try(each.value.account_id, null)
  region                     = try(each.value.region, null)
  email_notification         = try(each.value.email_notification, null)
  schedule                   = try(each.value.schedule, null)
  duration                   = try(each.value.duration, null)
  allow_unassociated_targets = try(each.value.allow_unassociated_targets, null)
  enabled                    = try(each.value.enabled, null)
  end_date                   = try(each.value.end_date, null)
  schedule_timezone          = try(each.value.schedule_timezone, null)
  schedule_offset            = try(each.value.schedule_offset, null)
  start_date                 = try(each.value.start_date, null)
  mw_name                    = try(each.value.mw_name, null)
  patch_group_tag_value      = try(each.value.patch_group_tag_value, null)
  operation                  = try(each.value.operation, null)
  reboot_option              = try(each.value.reboot_option, null)
  operating_system           = try(each.value.operating_system, null)
  approved_patches           = try(each.value.approved_patches, null)
  rejected_patches           = try(each.value.rejected_patches, null)
  approve_after_days         = try(each.value.approve_after_days, null)
  compliance_level           = try(each.value.compliance_level, null)
  enable_non_security        = try(each.value.enable_non_security, null)
  windows_patch_filter       = try(each.value.windows_patch_filter, null)
  debian_patch_filter        = try(each.value.debian_patch_filter, null)
  macos_patch_filter         = try(each.value.macos_patch_filter, null)
  default_patch_filter       = try(each.value.default_patch_filter, null)
  start_instance             = try(each.value.start_instance, null)
  schedule_start             = try(each.value.schedule_start, null)
  stop_instance              = try(each.value.stop_instance, null)
  schedule_stop              = try(each.value.schedule_stop, null)
}}
"""

    alias = region.replace("-", "")
    return module_template.format(alias=alias, region=region)

def main(input_file, output_file):
    with open(input_file, 'r') as file:
        reader = csv.DictReader(file)
        regions = set(row['region'] for row in reader)

    module_config = ""
    for region in regions:
        module_config += generate_module(region) + "\n"

    with open(output_file, 'w') as outfile:
        outfile.write(module_config)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_csv_file> <output_tf_file>")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file, output_file)
