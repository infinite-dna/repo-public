Author  Stan Zvenigorodskiy email: stanislav.zvenigorodskiy@infinite.com

To test data flow inside an Azure account and ensure that all data is encrypted, you can create a script that checks various Azure services and their encryption settings. Below is a simple example of a script written in Python that uses the Azure SDK for Python to check encryption settings for some common Azure services. Before running the script, make sure to install the required Azure SDK by running `pip install azure-mgmt-compute azure-mgmt-storage azure-mgmt-network`.

```python
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient
from azure.mgmt.storage import StorageManagementClient
from azure.mgmt.network import NetworkManagementClient

def check_vm_encryption(credentials, subscription_id, resource_group, vm_name):
    compute_client = ComputeManagementClient(credentials, subscription_id)

    vm = compute_client.virtual_machines.get(resource_group, vm_name)
    os_disk = vm.storage_profile.os_disk

    encryption_settings = os_disk.encryption_settings
    if encryption_settings is not None and encryption_settings.disk_encryption_set_id is not None:
        print(f"VM {vm_name} OS disk is encrypted.")
    else:
        print(f"VM {vm_name} OS disk is not encrypted.")

def check_storage_account_encryption(credentials, subscription_id, resource_group, storage_account_name):
    storage_client = StorageManagementClient(credentials, subscription_id)

    account = storage_client.storage_accounts.get_properties(resource_group, storage_account_name)
    encryption = account.encryption

    if encryption is not None and encryption.services.blob is not None:
        print(f"Storage account {storage_account_name} is encrypted.")
    else:
        print(f"Storage account {storage_account_name} is not encrypted.")

def check_network_security_group_encryption(credentials, subscription_id, resource_group, nsg_name):
    network_client = NetworkManagementClient(credentials, subscription_id)

    nsg = network_client.network_security_groups.get(resource_group, nsg_name)
    if nsg.default_security_rules is not None:
        print(f"Network Security Group {nsg_name} has default rules.")

    if nsg.security_rules is not None:
        print(f"Network Security Group {nsg_name} has custom security rules.")

# Use DefaultAzureCredential to authenticate with Azure
credentials = DefaultAzureCredential()

# Set your Azure subscription ID and resource group name
subscription_id = "your_subscription_id"
resource_group = "your_resource_group"

# Set names of resources to check
vm_name = "your_vm_name"
storage_account_name = "your_storage_account_name"
nsg_name = "your_network_security_group_name"

# Check encryption for VM, Storage Account, and Network Security Group
check_vm_encryption(credentials, subscription_id, resource_group, vm_name)
check_storage_account_encryption(credentials, subscription_id, resource_group, storage_account_name)
check_network_security_group_encryption(credentials, subscription_id, resource_group, nsg_name)
```

Replace the placeholder values with your actual Azure subscription ID, resource group name, and the names of the resources you want to check. Note that this script is just a starting point and may need to be extended based on your specific Azure configuration and the services you use.

Please ensure that you have the necessary permissions to retrieve information about the resources in your Azure subscription.
