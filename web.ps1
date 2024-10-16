$resourceGroupName = 'webapp'
$appServicePlanName = 'CtosoASP'
$webAppName = "qewrwtwtyww"
$location = "EastUS"

# For Connecting to Azure account
Connect-AzAccount

# Create Resource Group (if it doesn't exist)
if (-not (Get-AzResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue)) {
    New-AzResourceGroup -Name $resourceGroupName -Location $location
    Write-Output "Resource group '$resourceGroupName' created in location '$location'."
} else {
    Write-Output "Resource group '$resourceGroupName' already exists."
}

# Create an App Service Plan
$servicePlan = New-AzAppServicePlan -Name $appServicePlanName -ResourceGroupName $resourceGroupName -Location $location -Tier "Basic" -NumberofWorkers 2 -WorkerSize "Small"

#For creating webapp
$webApp = New-AzWebApp -Name $webAppName -ResourceGroupName $resourceGroupName -Location $location -AppServicePlan $servicePlan.Id

# Output result
Write-Output "Web-App '$webAppName' is created in the resource Group '$resourceGroupName' with Appservice plan '$servicePlan'"

