import csv
import sys

def generate_tfvars(input_csv, output_tfvars):
    with open(input_csv, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        row = next(reader)  # Assuming there's only one row in the CSV
        
        # Open tfvars file for writing
        with open(output_tfvars, 'w') as tfvars_file:
            # Write variable assignments to the tfvars file
            tfvars_file.write(f"""\
account_id                 = {row['account_id']}
region                     = "{row['region']}"
email_notification         = "{row['email_notification']}"
mw_name                    = "{row['mw_name']}"
schedule                   = "{row['schedule']}"
duration                   = {row['duration']}
allow_unassociated_targets = {row['allow_unassociated_targets']}
enabled                    = {row['enabled']}
schedule_timezone          = "{row['schedule_timezone']}"
patch_group_tag_value      = "{row['patch_group_tag_value']}"
operation                  = {row['operation']}
reboot_option              = {row['reboot_option']}
operating_system           = "{row['operating_system']}"
start_instance             = "{row['start_instance']}"
""")
            
            # Write filters to the tfvars file
            if row['operating_system'] == 'windows':
                tfvars_file.write(f"""\
windows_patch_filter = {{
  PRODUCT_FAMILY = {row['PRODUCT_FAMILY']},
  CLASSIFICATION = {row['CLASSIFICATION']},
  MSRC_SEVERITY  = {row['MSRC_SEVERITY']}
}}
""")
            elif row['operating_system'] == 'debian':
                tfvars_file.write(f"""\
debian_patch_filter = {{
  PRODUCT  = {row['PRODUCT']},
  PRIORITY = {row['PRIORITY']}
}}
""")
            elif row['operating_system'] == 'ubuntu':
                tfvars_file.write(f"""\
ubuntu_patch_filter = {{
  PRODUCT  = {row['PRODUCT']},
  PRIORITY = {row['PRIORITY']}
}}
""")
            elif row['operating_system'] == 'macos':
                tfvars_file.write(f"""\
macos_patch_filter = {{
  PRODUCT        = {row['PRODUCT']},
  CLASSIFICATION = {row['CLASSIFICATION']}
}}
""")
            else:
                tfvars_file.write(f"""\
default_patch_filter = {{
  PRODUCT        = {row['PRODUCT']},
  CLASSIFICATION = {row['CLASSIFICATION']},
  SEVERITY       = {row['SEVERITY']}
}}
""")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_tfvars.py <input_csv> <output_tfvars>")
        sys.exit(1)

    input_csv = sys.argv[1]
    output_tfvars = sys.argv[2]

    generate_tfvars(input_csv, output_tfvars)
