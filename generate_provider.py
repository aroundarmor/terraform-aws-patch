import csv
import sys

def generate_provider(region):
    provider_template = """
provider "aws" {{
  region = "{region}"
  alias  = "{alias}"
  default_tags {{
    tags = {{
      ManagedBy = "Ollion"
    }}
  }}
}}
"""

    alias = region.replace("-", "")
    return provider_template.format(region=region, alias=alias)

def main(input_file, output_file):
    with open(input_file, 'r') as file:
        reader = csv.DictReader(file)
        regions = set(row['region'] for row in reader)

    provider_config = ""
    for region in regions:
        provider_config += generate_provider(region) + "\n"

    provider_config = 'terraform {\n  required_providers {\n    aws = {\n      source = "hashicorp/aws"\n    }\n  }\n}\n\n' + provider_config

    with open(output_file, 'w') as outfile:
        outfile.write(provider_config)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_csv_file> <output_tf_file>")
        sys.exit(1)
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    main(input_file, output_file)
