
Author: Stan Zvenigorodskiy email:Stanislav.Zvenigorodskiy@invinite.com

+---------------------------------------------------------+
|                         Azure Cloud                        |
|                                                            |
|                     +---------------------+                |
|                     |     Virtual Network |                |
|                     |                     |                |
|                     +---------+-----------+                |
|                               |                            |
|                               |                            |
|          +-------------------+-------------------+         |
|          |              Subnet: Web UI             |       |
|          |   +-----------------------------+       |       |
|          |   | Auto-Scaling Load Balancer  |       |       |
|          |   +-----------------------------+       |       |
|          |   |         +---+ +---+ +---+  |        |       |
|          |   |         |VM1| |VM2| |VM3|  |        |       |
|          |   +---------+---+ +---+ +---+--+        |       |
|          |                                         |       |
|          |           Subnet: API                   |       |
|          |   +-----------------------------+       |       |
|          |   | Auto-Scaling Load Balancer  |       |       |
|          |   +-----------------------------+       |       |
|          |   |         +---+ +---+ +---+  |        |       |
|          |   |         |VM4| |VM5| |VM6|  |        |       |
|          |   +---------+---+ +---+ +---+--+        |       |
|          |                                         |       |
|          |           Subnet: DNA Connect App       |       |
|          |   +-----------------------------+       |       |
|          |   | Auto-Scaling Load Balancer  |       |       |
|          |   +-----------------------------+       |       |
|          |   |         +---+ +---+ +---+  |        |       |
|          |   |         |VM7| |VM8| |VM9|  |        |       |
|          |   +---------+---+ +---+ +---+--+        |       |
|          |                                         |       |
|          |           Subnet: Database (Oracle)     |       |
|          |   +-----------------------------+       |       |
|          |   |     Auto-Scaling for HA     |       |       |
|          |   |                             |       |       |
|          |   |         +-----------------+ |       |       |
|          |   |         | Oracle Database | |       |       |
|          |   |         +-----------------+ |       |       |
|          |   +-----------------------------+       |       |
|          |                                         |       |
|          |           Subnet: SQL Always On         |       |       |
|          |   +-----------------------------+       |       |
|          |   | Auto-Scaling for HA (2 VMs) |       |       |
|          |   +-----------------------------+       |       |
|          |   |         +---+ +---+         |       |       |
|          |   |         |VM10| |VM11|       |       |       |
|          |   +---------+---+ +---+-----------+     |       |
|          |                                         |       |
|          |        Disaster Recovery Environment    |       |
|          |   +-----------------------------+       |       |
|          |   |  Recovery Services Vault   |        |       |
|          |   |                             |       |       |
|          |   |                             |       |       |
|          |   |                             |       |       |
|          |   +-----------------------------+       |       |
|          |   | Recovery Services Container |       |       |
|          |   |                             |       |       |
|          |   +-----------------------------+       |       |
|          |   |   Recovery Policy           |       |       |
|          |   |                             |       |       |
|          |   +-----------------------------+       |       |
|          |   | Replication Protected Item  |       |       |
|          |   +-----------------------------+       |       |
+---------------------------------------------------------+

```


 DNA Migrations Terraform framework:

```

terraform/
|-- main.tf
|-- variables.tf
|-- production.tfvars
|-- uat.tfvars
|-- dr.tf
|-- network/
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   |-- documentation/
|   |   |-- network.md
|-- vms/  <-- Updated from "compute" to "vms"
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   |-- web_ui/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- web_ui.md
|   |-- api/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- api.md
|-- database/
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   |-- oracle_database/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- oracle_database.md
|   |-- sql_always_on/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- sql_always_on.md
|-- security/
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   |-- network_security/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- network_security.md
|   |-- encryption/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- encryption.md
|-- scheduled_shutdown/
|   |-- main.tf
|   |-- variables.tf
|   |-- outputs.tf
|   |-- documentation/
|   |   |-- scheduled_shutdown.md
|-- dr/
|   |-- asr_vms/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- asr_vms.md
|   |-- oracle_dr/
|   |   |-- main.tf
|   |   |-- variables.tf
|   |   |-- outputs.tf
|   |   |-- documentation/
|   |   |   |-- oracle_dr.md
|-- documentation/
|   |-- main.md


**Detailed Explanations:**

1. **`main.tf`:**
   - Orchestrates the deployment, includes provider configuration, and references modules.

2. **`variables.tf`:**
   - Defines input variables used across modules.

3. **`production.tfvars` and `uat.tfvars`:**
   - Specific configurations for production and UAT environments.

4. **`dr.tf`:**
   - Sets up disaster recovery configurations using Azure Site Recovery (ASR) and Oracle Database replication.

5. **`network/`:**
   - **`main.tf`:** Creates the Azure Virtual Network, subnets, security groups, and other network-related resources.
   - **`variables.tf`:** Defines variables for the network module.
   - **`outputs.tf`:** Defines outputs such as the ID of the main virtual network.
   - **`documentation/`:** Contains detailed documentation for the network module.

6. **`vms/`:**
   - **`main.tf`:** Contains the main configurations for virtual machines, load balancers, etc.
   - **`variables.tf`:** Defines variables for the VMs module.
   - **`outputs.tf`:** Defines outputs such as public IPs of VMs.
   - **`web_ui/`:** Configures the web UI components.
   - **`api/`:** Configures the API components.
   - **`documentation/`:** Contains detailed documentation for the VMs module and its submodules.

7. **`database/`:**
   - **`main.tf`:** Configures the Oracle Database and SQL Always On instances.
   - **`variables.tf`:** Defines variables for the database module.
   - **`outputs.tf`:** Defines outputs such as the Oracle Database endpoint and SQL Always On IPs.
   - **`oracle_database/`:** Configures the Oracle Database.
   - **`sql_always_on/`:** Configures SQL Always On instances.
   - **`documentation/`:** Contains detailed documentation for the database module and its submodules.

8. **`security/`:**
   - **`main.tf`:** Configures network security groups and encryption.
   - **`variables.tf`:** Defines variables for the security module.
   - **`outputs.tf`:** Defines outputs such as NSG IDs and encryption keys.
   - **`network_security/`:** Configures network security groups.
   - **`encryption/`:** Configures encryption settings.
   - **`documentation/`:** Contains detailed documentation for the security module and its submodules.

9. **`scheduled_shutdown/`:**
   - **`main.tf`:** Configures scheduled shutdowns using Azure Automation.
   - **`variables.tf`:** Defines variables for the scheduled shutdown module.
   - **`outputs.tf`:** Defines outputs such as the Azure Automation Account ID.
   - **`documentation/`:** Contains detailed documentation for the scheduled shutdown module.

10. **`dr/`:**
    - **`asr_vms/`:** Configures Azure Site Recovery for VMs.
    - **`oracle_dr/`:** Configures Oracle Database replication for disaster recovery.

11. **`documentation/`:**
    - **`main.md`:** Main documentation file providing an overview of the entire project.

Customize this structure and content based on your specific infrastructure needs.

Certainly! Let's go through each of the specified files, provide detailed explanations for each block, and show example outputs.

### 1. `main.tf`:

```hcl
# main.tf

provider "azurerm" {
  features = {}
}

module "network" {
  source = "./network"
}

module "vms" {
  source         = "./vms"
  image_version  = var.image_version
}

module "database" {
  source         = "./database"
  image_version  = var.image_version
}

module "security" {
  source = "./security"
}

module "scheduled_shutdown" {
  source              = "./scheduled_shutdown"
  resource_group_name = var.resource_group_name
  location            = var.location
  shutdown_time       = var.shutdown_time
  weekend_shutdown    = var.weekend_shutdown
}

module "disaster_recovery" {
  source              = "./dr"
  resource_group_name = var.resource_group_name
  location            = var.location
}
```

**Explanation:**
- **Provider Block:** Configures the AzureRM provider.
- **Module Blocks:** References separate modules for various components like network, VMs, database, security, scheduled shutdown, and disaster recovery.
- **Variables:** Utilizes input variables such as `image_version`, `resource_group_name`, `location`, `shutdown_time`, and `weekend_shutdown`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "image_version" {
  description = "Version of the VM image to use"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "shutdown_time" {
  description = "Time at which VMs should be shut down (in 24-hour format, e.g., '18:00')"
  type        = string
}

variable "weekend_shutdown" {
  description = "Flag to enable or disable VM shutdown during weekends"
  type        = bool
  default     = true
}
```

**Explanation:**
- Defines input variables used across the modules.
- Variables include `resource_group_name`, `image_version`, `location`, `shutdown_time`, and `weekend_shutdown`.

### 3. `production.tfvars`:

```hcl
# production.tfvars

resource_group_name = "prod-rg"
image_version       = "v1.0"
location            = "East US"
shutdown_time       = "22:00"
weekend_shutdown    = true
```

**Explanation:**
- Specific configurations for the production environment.
- Sets values for variables like `resource_group_name`, `image_version`, `location`, `shutdown_time`, and `weekend_shutdown`.

### 4. `uat.tfvars`:

```hcl
# uat.tfvars

resource_group_name = "uat-rg"
image_version       = "v1.1"
location            = "West US"
shutdown_time       = "20:00"
weekend_shutdown    = false
```

**Explanation:**
- Specific configurations for the UAT (User Acceptance Testing) environment.
- Similar to `production.tfvars` but with different values for variables.

### 5. `dr.tf`:

```hcl
# dr.tf

module "disaster_recovery" {
  source              = "./dr"
  resource_group_name = var.resource_group_name
  location            = var.location
  dr_enabled           = true
}
```

**Explanation:**
- Utilizes a disaster recovery module for setting up Azure Site Recovery (ASR) or other recovery configurations.
- References variables like `resource_group_name` and `location`.

These files collectively provide the necessary configurations and variables for deploying and managing your infrastructure. Customize the values based on your specific requirements.

Certainly! Let's go through each file in the `network` module, providing detailed explanations for each Terraform block.

### 1. `main.tf`:

```hcl
# main.tf

resource "azurerm_virtual_network" "main" {
  name                = var.virtual_network_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}
```

**Explanation:**
- Defines an Azure Virtual Network using the `azurerm_virtual_network` resource.
- Utilizes variables like `virtual_network_name`, `address_space`, `location`, and `resource_group_name`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "virtual_network_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Address space of the Virtual Network"
  type        = list(string)
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}
```

**Explanation:**
- Declares input variables used in `main.tf`.
- Variables include `virtual_network_name`, `address_space`, `location`, and `resource_group_name`.

### 3. `outputs.tf`:

```hcl
# outputs.tf

output "virtual_network_id" {
  description = "ID of the Azure Virtual Network"
  value       = azurerm_virtual_network.main.id
}
```

**Explanation:**
- Defines an output to expose the ID of the created Virtual Network.
- This ID can be referenced by other modules.

### 4. `documentation/network.md`:

```markdown
# Network Module

This module creates an Azure Virtual Network.

## Resources Created

- Azure Virtual Network

## Input Variables

- `virtual_network_name`: Name of the Azure Virtual Network.
- `address_space`: Address space of the Virtual Network.
- `location`: Azure region.
- `resource_group_name`: Name of the Azure Resource Group.

## Outputs

- `virtual_network_id`: ID of the Azure Virtual Network.
```

**Explanation:**
- Markdown file providing documentation for the network module.
- Describes the purpose of the module, resources created, input variables, and outputs.

These files collectively define an Azure Virtual Network and document the module's purpose and usage. Customize the variables and resources based on your specific network requirements.

Certainly! Let's go through each file in the `vms` module, providing detailed explanations for each Terraform block.

### 1. `main.tf`:

```hcl
# main.tf

module "web_ui" {
  source              = "./vms/web_ui"
  virtual_network_id  = var.virtual_network_id
  subnet_id           = var.subnet_id_web_ui
  image_version       = var.image_version
  instance_count      = var.web_ui_instance_count
}

module "api" {
  source              = "./vms/api"
  virtual_network_id  = var.virtual_network_id
  subnet_id           = var.subnet_id_api
  image_version       = var.image_version
  instance_count      = var.api_instance_count
}
```

**Explanation:**
- References submodules for creating VM instances for the web UI and API components.
- Passes variables like `virtual_network_id`, `subnet_id_web_ui`, `subnet_id_api`, `image_version`, `web_ui_instance_count`, and `api_instance_count`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "virtual_network_id" {
  description = "ID of the Azure Virtual Network"
  type        = string
}

variable "subnet_id_web_ui" {
  description = "ID of the subnet for the Web UI VMs"
  type        = string
}

variable "subnet_id_api" {
  description = "ID of the subnet for the API VMs"
  type        = string
}

variable "image_version" {
  description = "Version of the VM image to use"
  type        = string
}

variable "web_ui_instance_count" {
  description = "Number of instances for the Web UI VMs"
  type        = number
}

variable "api_instance_count" {
  description = "Number of instances for the API VMs"
  type        = number
}
```

**Explanation:**
- Defines input variables used in `main.tf`.
- Variables include `virtual_network_id`, `subnet_id_web_ui`, `subnet_id_api`, `image_version`, `web_ui_instance_count`, and `api_instance_count`.

### 3. `outputs.tf`:

```hcl
# outputs.tf

output "web_ui_instance_ips" {
  description = "Public IPs of the Web UI instances"
  value       = module.web_ui.public_ips
}

output "api_instance_ips" {
  description = "Public IPs of the API instances"
  value       = module.api.public_ips
}
```

**Explanation:**
- Defines outputs to expose the public IPs of the created VM instances.
- These outputs can be referenced by other modules.

### 4. `web_ui/main.tf`:

```hcl
# web_ui/main.tf

resource "azurerm_windows_virtual_machine" "web_ui" {
  count                    = var.instance_count
  name                     = "web-ui-${count.index + 1}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  virtual_network_subnet_id = var.subnet_id
  ...

  // Additional configurations for the Web UI VM instance
}
```

**Explanation:**
- Creates Windows Virtual Machines for the Web UI.
- Utilizes variables like `instance_count`, `location`, `resource_group_name`, `subnet_id`, and additional configurations.

### 5. `web_ui/variables.tf`:

```hcl
# web_ui/variables.tf

variable "subnet_id" {
  description = "ID of the subnet for the Web UI VMs"
  type        = string
}
```

**Explanation:**
- Defines input variables specific to the Web UI submodule.

### 6. `web_ui/outputs.tf`:

```hcl
# web_ui/outputs.tf

output "public_ips" {
  description = "Public IPs of the Web UI instances"
  value       = azurerm_windows_virtual_machine.web_ui[*].public_ip_address
}
```

**Explanation:**
- Defines an output specific to the Web UI submodule to expose public IPs.

### 7. `api/main.tf`:

```hcl
# api/main.tf

resource "azurerm_windows_virtual_machine" "api" {
  count                    = var.instance_count
  name                     = "api-${count.index + 1}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  virtual_network_subnet_id = var.subnet_id
  ...

  // Additional configurations for the API VM instance
}
```

**Explanation:**
- Creates Windows Virtual Machines for the API.
- Utilizes variables like `instance_count`, `location`, `resource_group_name`, `subnet_id`, and additional configurations.

### 8. `api/variables.tf`:

```hcl
# api/variables.tf

variable "subnet_id" {
  description = "ID of the subnet for the API VMs"
  type        = string
}
```

**Explanation:**
- Defines input variables specific to the API submodule.

### 9. `api/outputs.tf`:

```hcl
# api/outputs.tf

output "public_ips" {
  description = "Public IPs of the API instances"
  value       = azurerm_windows_virtual_machine.api[*].public_ip_address
}
```

**Explanation:**
- Defines an output specific to the API submodule to expose public IPs.

These files collectively define and organize the creation of virtual machines for the web UI and API components within the `vms` module. Adjust the configurations based on your specific VM requirements.

Certainly! Let's go through each file in the `database` module, providing detailed explanations for each Terraform block.

### 1. `main.tf`:

```hcl
# main.tf

module "oracle_database" {
  source               = "./database/oracle_database"
  virtual_network_id   = var.virtual_network_id
  subnet_id            = var.subnet_id_oracle
  image_version        = var.image_version
  instance_count       = var.oracle_instance_count
}

module "sql_always_on" {
  source               = "./database/sql_always_on"
  virtual_network_id   = var.virtual_network_id
  subnet_id            = var.subnet_id_sql
  image_version        = var.image_version
  instance_count       = var.sql_instance_count
}
```

**Explanation:**
- References submodules for creating Oracle Database and SQL Always On instances.
- Passes variables like `virtual_network_id`, `subnet_id_oracle`, `subnet_id_sql`, `image_version`, `oracle_instance_count`, and `sql_instance_count`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "virtual_network_id" {
  description = "ID of the Azure Virtual Network"
  type        = string
}

variable "subnet_id_oracle" {
  description = "ID of the subnet for Oracle Database instances"
  type        = string
}

variable "subnet_id_sql" {
  description = "ID of the subnet for SQL Always On instances"
  type        = string
}

variable "image_version" {
  description = "Version of the VM image to use"
  type        = string
}

variable "oracle_instance_count" {
  description = "Number of instances for Oracle Database"
  type        = number
}

variable "sql_instance_count" {
  description = "Number of instances for SQL Always On"
  type        = number
}
```

**Explanation:**
- Declares input variables used in `main.tf`.
- Variables include `virtual_network_id`, `subnet_id_oracle`, `subnet_id_sql`, `image_version`, `oracle_instance_count`, and `sql_instance_count`.

### 3. `outputs.tf`:

```hcl
# outputs.tf

output "oracle_instance_ips" {
  description = "Public IPs of Oracle Database instances"
  value       = module.oracle_database.public_ips
}

output "sql_instance_ips" {
  description = "Public IPs of SQL Always On instances"
  value       = module.sql_always_on.public_ips
}
```

**Explanation:**
- Defines outputs to expose the public IPs of the created database instances.
- These outputs can be referenced by other modules.

### 4. `oracle_database/main.tf`:

```hcl
# oracle_database/main.tf

resource "azurerm_windows_virtual_machine" "oracle_database" {
  count                    = var.instance_count
  name                     = "oracle-db-${count.index + 1}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  virtual_network_subnet_id = var.subnet_id
  ...

  // Additional configurations for Oracle Database instance
}
```

**Explanation:**
- Creates Windows Virtual Machines for Oracle Database.
- Utilizes variables like `instance_count`, `location`, `resource_group_name`, `subnet_id`, and additional configurations.

### 5. `oracle_database/variables.tf`:

```hcl
# oracle_database/variables.tf

variable "subnet_id" {
  description = "ID of the subnet for Oracle Database instances"
  type        = string
}
```

**Explanation:**
- Defines input variables specific to the Oracle Database submodule.

### 6. `oracle_database/outputs.tf`:

```hcl
# oracle_database/outputs.tf

output "public_ips" {
  description = "Public IPs of Oracle Database instances"
  value       = azurerm_windows_virtual_machine.oracle_database[*].public_ip_address
}
```

**Explanation:**
- Defines an output specific to the Oracle Database submodule to expose public IPs.

### 7. `sql_always_on/main.tf`:

```hcl
# sql_always_on/main.tf

resource "azurerm_windows_virtual_machine" "sql_always_on" {
  count                    = var.instance_count
  name                     = "sql-always-on-${count.index + 1}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  virtual_network_subnet_id = var.subnet_id
  ...

  // Additional configurations for SQL Always On instance
}
```

**Explanation:**
- Creates Windows Virtual Machines for SQL Always On.
- Utilizes variables like `instance_count`, `location`, `resource_group_name`, `subnet_id`, and additional configurations.

### 8. `sql_always_on/variables.tf`:

```hcl
# sql_always_on/variables.tf

variable "subnet_id" {
  description = "ID of the subnet for SQL Always On instances"
  type        = string
}
```

**Explanation:**
- Defines input variables specific to the SQL Always On submodule.

### 9. `sql_always_on/outputs.tf`:

```hcl
# sql_always_on/outputs.tf

output "public_ips" {
  description = "Public IPs of SQL Always On instances"
  value       = azurerm_windows_virtual_machine.sql_always_on[*].public_ip_address
}
```

**Explanation:**
- Defines an output specific to the SQL Always On submodule to expose public IPs.

These files collectively define and organize the creation of database instances, including Oracle Database and SQL Always On components, within the `database` module. Adjust the configurations based on your specific database requirements.

Certainly! Let's go through each file in the `security` module, providing detailed explanations for each Terraform block.

### 1. `main.tf`:

```hcl
# main.tf

resource "azurerm_network_security_group" "security_group" {
  name                = var.security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  // Additional security rules can be added as needed
}
```

**Explanation:**
- Creates an Azure Network Security Group (NSG) with a security rule to allow incoming HTTP traffic.
- Utilizes variables like `security_group_name`, `location`, and `resource_group_name`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "security_group_name" {
  description = "Name of the Azure Network Security Group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}
```

**Explanation:**
- Declares input variables used in `main.tf`.
- Variables include `security_group_name`, `location`, and `resource_group_name`.

### 3. `outputs.tf`:

```hcl
# outputs.tf

output "security_group_id" {
  description = "ID of the Azure Network Security Group"
  value       = azurerm_network_security_group.security_group.id
}
```

**Explanation:**
- Defines an output to expose the ID of the created Network Security Group.
- This ID can be referenced by other modules.

These files collectively define and organize the creation of an Azure Network Security Group within the `security` module. Adjust the configurations based on your specific security requirements.

Certainly! Let's go through each file in the `scheduled_shutdown` module and provide detailed explanations for each Terraform block.

### 1. `main.tf`:

```hcl
# main.tf

resource "azurerm_automation_account" "automation_account" {
  name                = var.automation_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"
}

resource "azurerm_automation_schedule" "shutdown_schedule" {
  name                = "ShutdownSchedule"
  resource_group_name = azurerm_automation_account.automation_account.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  start_time          = var.shutdown_time
  description         = "Daily shutdown schedule"
  timezone            = "UTC"
  frequency           = "Day"
  interval            = 1
  occurrence          = 1
  advanced_schedule   = {
    week_days   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  }

  action {
    source  = "AzureVM"
    type    = "Stop"
    filter  = "tag:Shutdown"
    args    = "Deallocate"
  }
}
```

**Explanation:**
- Creates an Azure Automation Account and a daily shutdown schedule for virtual machines.
- Uses variables like `automation_account_name`, `location`, `resource_group_name`, and `shutdown_time`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "automation_account_name" {
  description = "Name of the Azure Automation Account"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "shutdown_time" {
  description = "Time at which VMs should be shut down (in 24-hour format, e.g., '18:00')"
  type        = string
  default     = "18:00"
}

variable "weekend_shutdown" {
  description = "Flag to enable or disable VM shutdown during weekends"
  type        = bool
  default     = true
}
```

**Explanation:**
- Declares input variables used in `main.tf`.
- Variables include `automation_account_name`, `location`, `resource_group_name`, `shutdown_time`, and `weekend_shutdown`.

### 3. `outputs.tf`:

```hcl
# outputs.tf

output "automation_account_id" {
  description = "ID of the Azure Automation Account"
  value       = azurerm_automation_account.automation_account.id
}

output "schedule_id" {
  description = "ID of the Azure Automation Schedule"
  value       = azurerm_automation_schedule.shutdown_schedule.id
}
```

**Explanation:**
- Defines outputs to expose the IDs of the created Automation Account and Schedule.
- These IDs can be referenced by other modules.

These files collectively define and organize the scheduled shutdown configuration within the `scheduled_shutdown` module. Adjust the configurations based on your specific requirements.

Certainly! Let's go through each file in the `dr` module and provide detailed explanations for each Terraform block.

### 1. `main.tf`:

```hcl
# main.tf

resource "azurerm_recovery_services_vault" "recovery_vault" {
  name                = var.recovery_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_site_recovery_protection_container" "protection_container" {
  name                = var.protection_container_name
  recovery_vault_id   = azurerm_recovery_services_vault.recovery_vault.id
}

resource "azurerm_site_recovery_policy" "recovery_policy" {
  name                     = "DefaultPolicy"
  recovery_vault_id        = azurerm_recovery_services_vault.recovery_vault.id
  recovery_protection_container_id = azurerm_site_recovery_protection_container.protection_container.id

  provider_specific_details {
    "instance_type" = "HyperVReplica2012"
  }
}

resource "azurerm_site_recovery_replication_protected_item" "protected_item" {
  name                     = "DefaultReplicaItem"
  recovery_vault_id        = azurerm_recovery_services_vault.recovery_vault.id
  recovery_protection_container_id = azurerm_site_recovery_protection_container.protection_container.id
  recovery_policy_id       = azurerm_site_recovery_policy.recovery_policy.id

  provider_specific_details {
    "instance_type" = "HyperVReplicaAzure"
  }
}
```

**Explanation:**
- Creates an Azure Recovery Services Vault, a protection container, a recovery policy, and a replication-protected item for disaster recovery.
- Uses variables like `recovery_vault_name`, `location`, and `resource_group_name`.

### 2. `variables.tf`:

```hcl
# variables.tf

variable "recovery_vault_name" {
  description = "Name of the Azure Recovery Services Vault"
  type        = string
}

variable "protection_container_name" {
  description = "Name of the Azure Site Recovery Protection Container"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}
```

**Explanation:**
- Declares input variables used in `main.tf`.
- Variables include `recovery_vault_name`, `protection_container_name`, `location`, and `resource_group_name`.

### 3. `outputs.tf`:

```hcl
# outputs.tf

output "recovery_vault_id" {
  description = "ID of the Azure Recovery Services Vault"
  value       = azurerm_recovery_services_vault.recovery_vault.id
}

output "protection_container_id" {
  description = "ID of the Azure Site Recovery Protection Container"
  value       = azurerm_site_recovery_protection_container.protection_container.id
}

output "recovery_policy_id" {
  description = "ID of the Azure Site Recovery Recovery Policy"
  value       = azurerm_site_recovery_policy.recovery_policy.id
}

output "protected_item_id" {
  description = "ID of the Azure Site Recovery Replication Protected Item"
  value       = azurerm_site_recovery_replication_protected_item.protected_item.id
}
```

**Explanation:**
- Defines outputs to expose the IDs of the created resources for reference.
- These IDs can be referenced by other modules.

These files collectively define and organize the configuration for disaster recovery within the `dr` module. Adjust the configurations based on your specific requirements.


Creating a highly secure environment in Azure involves implementing a combination of best practices across various components of your infrastructure. Below are detailed explanations on how to create a highly secure environment for the given modules in your Terraform framework:

### General Best Practices:

1. **Resource Naming Conventions:**
   - Establish clear and consistent naming conventions for resources to enhance manageability and reduce the risk of misconfiguration.

2. **Role-Based Access Control (RBAC):**
   - Implement RBAC to assign the principle of least privilege, ensuring that users and services have only the necessary permissions.

3. **Azure Policy and Blueprints:**
   - Use Azure Policy and Blueprints to enforce and audit compliance with organizational standards, security policies, and regulatory requirements.

### Network Module:

4. **Network Security Groups (NSGs):**
   - Utilize NSGs to control inbound and outbound traffic. Define rules based on the principle of least privilege, allowing only necessary traffic.

5. **Azure Bastion:**
   - Implement Azure Bastion for secure and seamless Remote Desktop Protocol (RDP) and Secure Shell (SSH) access to VMs, reducing exposure to attacks.

6. **Private Endpoints:**
   - Where applicable, use Azure Private Endpoints to secure access to Azure services by making them accessible only from within your virtual network.

### VMs Module:

7. **Azure Security Center:**
   - Enable Azure Security Center to monitor VM security, provide threat intelligence, and recommend actions to improve overall security posture.

8. **Just-In-Time Access (JIT):**
   - Implement JIT access to restrict access to VMs based on actual needs, reducing the attack surface and exposure to potential threats.

9. **Azure Monitor and Azure Security Center Integration:**
   - Integrate Azure Monitor and Azure Security Center for real-time monitoring, threat detection, and response.

### Database Module:

10. **Database Encryption:**
    - Enable Transparent Data Encryption (TDE) for Oracle Database and SQL Server to encrypt data at rest, adding an extra layer of protection.

11. **Database Auditing:**
    - Implement auditing at the database level to track and log database activity, facilitating detection and investigation of security incidents.

### Security Module:

12. **Azure Key Vault Integration:**
    - Integrate Azure Key Vault for centralized management of secrets, keys, and certificates, ensuring secure storage and retrieval.

13. **Secure Variables Handling in Terraform:**
    - Avoid hardcoding sensitive information in Terraform code. Utilize Azure Key Vault integration with Terraform for secure variable handling.

### Scheduled Shutdown Module:

14. **Network Security Groups (NSGs) for Automation Account:**
    - Restrict network access to the Automation Account using NSGs to minimize potential security risks.

### Disaster Recovery (DR) Module:

15. **Secure Recovery Services Vault:**
    - Implement strict access controls, such as RBAC, on the Recovery Services Vault to control and limit access to disaster recovery configurations.

16. **Network Security Controls for Replication:**
    - Implement NSGs or Azure Firewall to control and secure the network traffic between on-premises and Azure during replication.

### Best Practices for All Modules:

17. **Regular Security Audits and Penetration Testing:**
    - Conduct regular security audits and penetration testing to identify vulnerabilities and assess the effectiveness of security measures.

18. **Continuous Monitoring and Incident Response:**
    - Implement continuous monitoring solutions and establish an incident response plan to promptly address and mitigate security incidents.

19. **Security Education and Training:**
    - Provide ongoing security education and training for teams to increase awareness and foster a culture of security within the organization.

20. **Regular Updates and Patch Management:**
    - Implement regular updates and patch management processes to address vulnerabilities and enhance the security of all components.

By incorporating these best practices into your Terraform framework, you can build a highly secure environment in Azure that mitigates risks and provides a strong defense against potential threats. Regularly review and update security configurations to stay aligned with the evolving threat landscape and industry best practices.
Creating detailed Harness and GitLab CI/CD pipelines along with explanations is a complex task that requires extensive detail and specific configurations based on your environment, infrastructure, and requirements. However, I can provide a simplified example for both, along with explanations. Please note that these examples might need adjustments based on your specific setup.

### Harness Pipeline Example:

Assuming you have a Terraform project in your version control system and Harness connected to it:

1. **Source Integration:**
   - Connect your version control system (e.g., GitHub) as a Harness Source.

2. **Service:**
   - Create a Service in Harness:
     - Select the appropriate source (GitHub).
     - Connect it to your Terraform project.

3. **Workflow:**
   - Create a Workflow in Harness:
     - **Add Service Command:** Reference the Service you created.
     - **Terraform Apply Command:** Execute a Terraform apply command.

4. **Pipeline:**
   - Create a Pipeline in Harness:
     - **Workflow:** Use the Workflow you created.
     - **Triggers:** Set up triggers (e.g., Git commit, schedule) to start the pipeline.

### GitLab CI/CD Pipeline Example:

Assuming your Terraform code is in a GitLab repository:

1. **Create a `.gitlab-ci.yml` file in the root of your project:**

```yaml
stages:
  - deploy

variables:
  TF_WORKSPACE: "production"

deploy:
  stage: deploy
  script:
    - apt-get update -qy
    - apt-get install -y unzip
    - curl -fsSL https://releases.hashicorp.com/terraform/0.15.0/terraform_0.15.0_linux_amd64.zip -o terraform.zip
    - unzip terraform.zip -d /usr/local/bin/
    - cd path/to/your/terraform/code
    - terraform init -backend-config="backend-config.tfvars"
    - terraform workspace select $TF_WORKSPACE || terraform workspace new $TF_WORKSPACE
    - terraform apply -auto-approve
  only:
    - master
```

#### Explanation:

**Harness Pipeline:**
1. **Source Integration:**
   - Connects your version control system to Harness, allowing Harness to pull the Terraform code.

2. **Service:**
   - Creates a Harness Service that references your Terraform project in the connected version control system.

3. **Workflow:**
   - Defines a Harness Workflow that contains the necessary steps for deploying your Terraform project, such as initializing and applying Terraform configurations.

4. **Pipeline:**
   - Configures a Harness Pipeline that references the Workflow and sets up triggers for starting the pipeline (e.g., on Git commit or scheduled intervals).

**GitLab CI/CD Pipeline:**
1. **`.gitlab-ci.yml`:**
   - Defines a GitLab CI/CD pipeline with a single stage (`deploy`) that executes a series of commands to install Terraform, initialize the Terraform project, and apply changes.

#### Documentation:

1. **Harness Documentation:**
   - [Getting Started with Harness](https://docs.harness.io/docs/getting-started)
   - [Creating a Service](https://docs.harness.io/docs/services)
   - [Creating a Workflow](https://docs.harness.io/docs/workflows)
   - [Creating a Pipeline](https://docs.harness.io/docs/pipelines)

2. **GitLab CI/CD Documentation:**
   - [Introduction to CI/CD with GitLab](https://docs.gitlab.com/ee/ci/)
   - [Configuring `.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/yaml/)
   - [CI/CD Pipelines in GitLab](https://docs.gitlab.com/ee/ci/pipelines/)
   - [Variables in CI/CD](https://docs.gitlab.com/ee/ci/variables/)

These examples serve as a starting point. Ensure that you adjust them according to your specific requirements, integrate testing, approval gates, and other necessary steps based on your organization's policies and practices.


Certainly! Below is a simplified example of a Jenkinsfile that you can use to trigger a Terraform pipeline. This assumes you have a Jenkins server set up and configured with the necessary plugins for Git integration and the Terraform CLI.

```groovy
pipeline {
    agent any

    environment {
        TF_WORKSPACE = 'production'
    }

    stages {
        stage('Checkout') {
            steps {
                // Git checkout step
                checkout scm
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Install Terraform
                    def tfHome = tool 'Terraform'
                    env.PATH = "${tfHome}/bin:${env.PATH}"

                    // Navigate to the Terraform code directory
                    dir('path/to/your/terraform/code') {
                        // Initialize and apply Terraform changes
                        sh """
                        terraform init -backend-config=backend-config.tfvars
                        terraform workspace select \${TF_WORKSPACE} || terraform workspace new \${TF_WORKSPACE}
                        terraform apply -auto-approve
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            // Notification or additional steps on success
            echo 'Terraform apply successful!'
        }
        failure {
            // Notification or additional steps on failure
            echo 'Terraform apply failed!'
        }
    }
}
```

#### Explanation:

- **`agent any`:** Executes the pipeline on any available agent.

- **`environment`:** Declares the `TF_WORKSPACE` environment variable.

- **`stages`:** Defines the different stages of the pipeline.

- **`Checkout` stage:** Checks out the source code from the Git repository.

- **`Terraform Apply` stage:**
  - Installs Terraform using a configured tool in Jenkins.
  - Navigates to the Terraform code directory.
  - Initializes and applies Terraform changes.

- **`post` section:** Contains post-build actions.
  - `success`: Executes steps when the pipeline succeeds.
  - `failure`: Executes steps when the pipeline fails.

#### Notes:

- Ensure that the Jenkins server has the Terraform tool configured.
- Customize the paths and commands based on your project structure.
- Integrate appropriate notifications or additional steps in the `post` section.

#### Best Practices:

1. **Agent Selection:**
   - Choose an appropriate agent based on your project requirements.

2. **Environment Variables:**
   - Use the `environment` block to manage environment variables.

3. **Tool Configuration:**
   - Configure tools in Jenkins for better tool version management.

4. **Error Handling:**
   - Implement proper error handling and notifications in the `post` section.

5. **Pipeline Script Organization:**
   - Organize the pipeline script into stages for better readability.

6. **Security:**
   - Ensure secure handling of credentials and secrets.

7. **Version Control:**
   - Keep the Jenkinsfile version-controlled with your project.

Remember to adapt this example to match your specific Jenkins configuration, project structure, and security requirements.
