# Define variables
$resourceGroupName = "Resource"  # Change this to your desired resource group name
$location = "EastUS"                      # Change this to your desired location

# Connect to Azure
Connect-AzAccount

# Create the resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Output the result
Write-Output "Resource group '$resourceGroupName' created in location '$location'."
