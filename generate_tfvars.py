import csv
import sys

def generate_tfvars(input_csv, output_tfvars):
    with open(input_csv, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        mw_data = {}
        for row in reader:
            mw_name = row['mw_name']
            mw_data[mw_name] = {
                'mw_name': f'"{mw_name}"',
                'enabled': row['enabled'].lower(),
                'account_id': row['account_id'],
                'region': f'"{row["region"]}"',
                'email_notification': f'"{row["email_notification"]}"',
                'schedule': f'"{row["schedule"]}"',
                'schedule_start': f'"{row["schedule_start"]}"',
                'schedule_stop': f'"{row["schedule_stop"]}"',
                'duration': row['duration'],
                'allow_unassociated_targets': row['allow_unassociated_targets'].lower(),
                'schedule_timezone': f'"{row["schedule_timezone"]}"',
                'patch_group_tag_value': f'"{row["patch_group_tag_value"]}"',
                'operation': f'["{row["operation"]}"]',
                'reboot_option': f'["{row["reboot_option"]}"]',
                'operating_system': f'"{row["operating_system"].upper()}"',
                'approved_patches': '[]',
                'rejected_patches': '[]',
                'compliance_level': f'"{row["compliance_level"].upper()}"',
                'enable_non_security': row['enable_non_security'].lower(),
                'approve_after_days': row['approve_after_days'],
                'start_instance': f'"{row["start_instance"].upper()}"',
                'stop_instance': f'"{row["stop_instance"].upper()}"'
            }
            if row['operating_system'].upper() == 'WINDOWS':
                classification_values = [f'"{val.strip()}"' for val in row["CLASSIFICATION"].split(",")]
                PRODUCT_values = [f'"{val.strip()}"' for val in row["PRODUCT"].split(",")]
                msrc_severity_values = [f'"{val.strip()}"' for val in row["MSRC_SEVERITY"].split(",")]
                mw_data[mw_name]['windows_patch_filter'] = {
                    'CLASSIFICATION': f'[{", ".join(classification_values)}]',
                    'PRODUCT': f'[{", ".join(PRODUCT_values)}]',
                    'MSRC_SEVERITY': f'[{", ".join(msrc_severity_values)}]'
                }
            elif row['operating_system'].upper() == 'DEBIAN':
                product_values = [f'"{val.strip()}"' for val in row["PRODUCT"].split(",")]
                section_values = [f'"{val.strip()}"' for val in row["SECTION"].split(",")]
                priority_values = [f'"{val.strip()}"' for val in row["PRIORITY"].split(",")]
                mw_data[mw_name]['debian_patch_filter'] = {
                    'PRODUCT': f'[{", ".join(product_values)}]',
                    'SECTION': f'[{", ".join(section_values)}]',
                    'PRIORITY': f'[{", ".join(priority_values)}]'
                }
            elif row['operating_system'].upper() == 'UBUNTU':
                product_values = [f'"{val.strip()}"' for val in row["PRODUCT"].split(",")]
                section_values = [f'"{val.strip()}"' for val in row["SECTION"].split(",")]
                priority_values = [f'"{val.strip()}"' for val in row["PRIORITY"].split(",")]                
                mw_data[mw_name]['ubuntu_patch_filter'] = {
                    'PRODUCT': f'[{", ".join(product_values)}]',
                    'SECTION': f'[{", ".join(section_values)}]',
                    'PRIORITY': f'[{", ".join(priority_values)}]'
                }
            elif row['operating_system'].upper() == 'MACOS':
                product_values = [f'"{val.strip()}"' for val in row["PRODUCT"].split(",")]
                classification_values = [f'"{val.strip()}"' for val in row["CLASSIFICATION"].split(",")]
                mw_data[mw_name]['macos_patch_filter'] = {
                    'PRODUCT': f'[{", ".join(product_values)}]',
                    'CLASSIFICATION': f'[{", ".join(classification_values)}]'
                }
            else:
                product_values = [f'"{val.strip()}"' for val in row["PRODUCT"].split(",")]
                classification_values = [f'"{val.strip()}"' for val in row["CLASSIFICATION"].split(",")]
                severity_values = [f'"{val.strip()}"' for val in row["SEVERITY"].split(",")]
                mw_data[mw_name]['default_patch_filter'] = {
                    'PRODUCT': f'[{", ".join(product_values)}]',
                    'CLASSIFICATION': f'[{", ".join(classification_values)}]',
                    'SEVERITY': f'[{", ".join(severity_values)}]'
                }

        with open(output_tfvars, 'w') as tfvars_file:
            tfvars_file.write('maintenance_window = {\n')
            for mw_name, data in mw_data.items():
                tfvars_file.write(f'  {mw_name} = {{\n')
                for key, value in data.items():
                    if isinstance(value, dict):
                        tfvars_file.write(f'    {key} = {{\n')
                        for k, v in value.items():
                            tfvars_file.write(f'      {k} = {v}\n')
                        tfvars_file.write('    }\n')
                    else:
                        tfvars_file.write(f'    {key} = {value}\n')
                tfvars_file.write('  }\n')
            tfvars_file.write('}\n')

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python generate_tfvars.py <input_csv> <output_tfvars>")
        sys.exit(1)

    input_csv = sys.argv[1]
    output_tfvars = sys.argv[2]

    generate_tfvars(input_csv, output_tfvars)
