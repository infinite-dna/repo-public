Author: Stan Zvenigorodskiy email: stanislav.zvenigorodskiy@infinite.com


### Complete Go Program

Here is the complete Go program (`main.go`), including the Azure utilities package (`azureutils/azureutils.go`):

#### main.go
```go
package main

import (
	"context"
	"fmt"
	"log"

	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2019-12-01/compute"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/yourusername/azureutils" // Import your Azure utilities package
)

func main() {
	// Set your Azure subscription ID and resource group
	subscriptionID := "your-subscription-id"
	resourceGroup := "your-resource-group"

	// Authorize with Azure using environment variables
	authorizer, err := auth.NewAuthorizerFromEnvironment()
	if err != nil {
		log.Fatal("Error creating Azure authorizer:", err)
	}

	// Create a VM client
	vmClient := compute.NewVirtualMachinesClient(subscriptionID)
	vmClient.Authorizer = authorizer

	// Get the list of VMs in the specified resource group
	vms, err := vmClient.List(context.Background(), resourceGroup)
	if err != nil {
		log.Fatal("Error fetching VMs:", err)
	}

	// Iterate through each VM and perform update check
	for _, vm := range vms.Values() {
		updateStatus, err := azureutils.CheckForUpdates(*vm.Name)
		if err != nil {
			fmt.Printf("Error checking updates for VM %s: %v\n", *vm.Name, err)
			continue
		}
		fmt.Printf("Updates for VM %s: %s\n", *vm.Name, updateStatus)
	}
}
```

#### azureutils/azureutils.go
```go
package azureutils

import (
	"fmt"
)

// CheckForUpdates simulates checking for Windows updates on a VM.
func CheckForUpdates(vmName string) (string, error) {
	// Implement logic to connect to the VM and run PowerShell command
	// For demonstration purposes, returning a placeholder status
	return fmt.Sprintf("Updates checked for %s", vmName), nil
}
```

This script and Go program provide a comprehensive guide for integrating Azure VM update checking into your Git and Harness pipeline.

---

Note: Replace `<repository-url>` with the actual URL of your Git repository. Also, ensure that you have the necessary permissions and configurations in your Azure environment for the program to access VM information. Adjust environment variables as needed in the Harness pipeline.





### Git Pipeline Integration

#### Step 5: Git Workflow

1. **Clone the Repository:**
   ```bash
   git clone <repository-url>
   ```

2. **Create a Feature Branch:**
   ```bash
   git checkout -b feature/update-checker
   ```

3. **Commit Changes:**
   - Add the modified Go program and Azure utilities package.
   ```bash
   git add main.go
   git add azureutils/azureutils.go
   git commit -m "Add Azure VM update checker"
   ```

4. **Push Changes:**
   ```bash
   git push origin feature/update-checker
   ```

#### Step 6: Harness Pipeline Integration

1. **Create a New Harness Pipeline:**
   - Navigate to your Harness environment and create a new pipeline.

2. **Add a Source Step:**
   - Connect to your Git repository and select the `feature/update-checker` branch.

3. **Add a Shell Script Step:**
   - Use the following script to run the Go program.
   ```bash
   #!/bin/bash

   # Install dependencies
   go get -u github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2019-12-01/compute
   go get -u github.com/Azure/go-autorest/autorest/azure/auth

   # Run Go program
   go run main.go
   ```

4. **Define Environment Variables:**
   - Add environment variables for Azure credentials and any other required parameters.
   ```bash
   export AZURE_SUBSCRIPTION_ID="your-subscription-id"
   export AZURE_RESOURCE_GROUP="your-resource-group"
   ```

5. **Save and Deploy:**
   - Save the pipeline and trigger a deployment.
