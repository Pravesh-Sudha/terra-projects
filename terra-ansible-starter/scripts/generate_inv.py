import json

# Paths (adjust if needed)
terraform_output_path = "terra-config/output.json"
inventory_path = "ansible/inventory/hosts.ini"

# Load Terraform output JSON

with open(terraform_output_path, "r") as f:
    data = json.load(f)
    

# Start writing to inventory file
with open(inventory_path, "w") as inv:
    for env, ips in data.items():
        inv.write(f"[{env}]\n")
        for ip in ips:
            inv.write(f"{ip}\n")
        inv.write("\n")

    # Add global vars
    inv.write("[all:vars]\n")
    inv.write("ansible_user=ubuntu\n")
    inv.write("ansible_ssh_private_key_file=~/.ssh/appKey\n")
    inv.write("ansible_python_interpreter=/usr/bin/python3\n\n")

    # Add per-env vars
    for env in data.keys():
        inv.write(f"[{env}:vars]\n")
        inv.write(f"env={env}\n\n")

print(f"✅ Inventory generated successfully at {inventory_path}")
