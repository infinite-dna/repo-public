Ansible framework that includes roles for installing IIS Server on `iis_vm`, deploying a .NET application with its dependencies on `api_vm`, migrating Oracle DB from on-premises to Azure cloud, and running the latest Windows updates.

### Directory Structure:

```plaintext
ansible-migration-framework/
|-- deploy_iis.yml
|-- deploy_api.yml
|-- migrate_oracle_db.yml
|-- update_windows.yml
|-- inventory.ini
|-- roles/
|   |-- iis/
|       |-- tasks/
|           |-- main.yml
|       |-- vars/
|           |-- main.yml
|   |-- api/
|       |-- tasks/
|           |-- main.yml
|       |-- vars/
|           |-- main.yml
|   |-- oracle_db/
|       |-- tasks/
|           |-- main.yml
|       |-- vars/
|           |-- main.yml
|   |-- update_windows/
|       |-- tasks/
|           |-- main.yml
```

### `deploy_iis.yml`:

```yaml
# deploy_iis.yml
- hosts: iis_vm
  roles:
    - iis
```

### `roles/iis/tasks/main.yml`:

```yaml
# roles/iis/tasks/main.yml
- name: Install IIS Server
  win_feature:
    name: Web-Server
    state: present
    restart: yes

- name: Install ASP.NET
  win_feature:
    name: Web-Asp-Net45
    state: present
    restart: yes

# Add other tasks as needed
```

### `roles/iis/vars/main.yml`:

```yaml
# roles/iis/vars/main.yml
iis_vm_name: "iis-vm-01"
```

### `deploy_api.yml`:

```yaml
# deploy_api.yml
- hosts: api_vm
  roles:
    - api
```

### `roles/api/tasks/main.yml`:

```yaml
# roles/api/tasks/main.yml
- name: Install .NET Core Runtime
  win_chocolatey:
    name: dotnetcore-runtime
    state: present

- name: Deploy API Application
  win_copy:
    src: "path/to/api/app"
    dest: "C:/Path/To/Deploy/App"

# Add other tasks as needed
```

### `roles/api/vars/main.yml`:

```yaml
# roles/api/vars/main.yml
api_vm_name: "api-vm-01"
```

### `migrate_oracle_db.yml`:

```yaml
# migrate_oracle_db.yml
- hosts: oracle_db_vm
  roles:
    - oracle_db
```

### `roles/oracle_db/tasks/main.yml`:

```yaml
# roles/oracle_db/tasks/main.yml
- name: Migrate Oracle DB to Azure
  # Add tasks to migrate Oracle DB to Azure using Azure Database Migration Service or other suitable methods

# Add other tasks as needed
```

### `roles/oracle_db/vars/main.yml`:

```yaml
# roles/oracle_db/vars/main.yml
oracle_db_vm_name: "oracle-db-vm-01"
```

### `update_windows.yml`:

```yaml
# update_windows.yml
- hosts: all
  roles:
    - update_windows
```

### `roles/update_windows/tasks/main.yml`:

```yaml
# roles/update_windows/tasks/main.yml
- name: Update Windows
  win_updates:
    category_names:
      - SecurityUpdates
      - UpdateRollups
      - CriticalUpdates
    state: installed
```

### `inventory.ini`:

```ini
# inventory.ini
[iis_vm]
iis-vm-01 ansible_host=10.0.1.2

[api_vm]
api-vm-01 ansible_host=10.0.2.2

[oracle_db_vm]
oracle-db-vm-01 ansible_host=10.0.3.2
```

### Usage:

1. Update the placeholder values in `roles/iis/vars/main.yml`, `roles/api/vars/main.yml`, and `roles/oracle_db/vars/main.yml`.
2. Replace `"path/to/api/app"` in `roles/api/tasks/main.yml` with the actual path to your .NET API application.
3. Execute the deployment and migration playbooks:

   ```bash
   ansible-playbook -i inventory.ini deploy_iis.yml
   ansible-playbook -i inventory.ini deploy_api.yml
   ansible-playbook -i inventory.ini migrate_oracle_db.yml
   ansible-playbook -i inventory.ini update_windows.yml
   ```

Adjust this example based on your actual deployment, migration, and update requirements. Ensure that Ansible has the necessary permissions and connectivity to the target VMs and Oracle Database in your Azure environment.
