import csv
import sys

def process_csv(file_path):
    processed_data = {}
    with open(file_path, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            for key, value in row.items():
                processed_data[key.strip()] = value.strip()
    return processed_data

def append_variables_tf(processed_data):
    with open('variables.tf', 'a') as file:
        file.write('''
variable "mw_name" {
    type = string
    default = "%s"
}

variable "account_number" {
    type = string
    default = "%s"
}

variable "region" {
    type = string
    default = "%s"
}

variable "operation" {
    type = string
    default = "%s"
}

variable "patch_schedule" {
    type = string
    default = "%s"
}

variable "patch_group_tag" {
    type = string
    default = "%s"
}

variable "patch_group_tag_value" {
    type = string
    default = "%s"
}

variable "reboot" {
    type = string
    default = "%s"
}

variable "offset" {
    type = string
    default = "%s"
}

variable "az_patching" {
    type = string
    default = "%s"
}

variable "duration" {
    type = number
    default = %s
}

variable "start_instances" {
    type = string
    default = "%s"
}
''' % (processed_data.get("MW_Name", ""),
       processed_data.get("AccountNumber", ""),
       processed_data.get("Region", ""),
       processed_data.get("Operation", ""),
       processed_data.get("Patch Schedule", ""),
       processed_data.get("PatchGroupTag", ""),
       processed_data.get("PatchGroupTagValue", ""),
       processed_data.get("Reboot", ""),
       processed_data.get("Offset", ""),
       processed_data.get("AZ_Patching", ""),
       processed_data.get("Duration", ""),
       processed_data.get("Start_Instances", "")))

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python process_csv.py <path_to_csv>")
        sys.exit(1)

    csv_file_path = sys.argv[1]
    processed_data = process_csv(csv_file_path)
    append_variables_tf(processed_data)
    print("New variables have been appended to variables.tf.")
