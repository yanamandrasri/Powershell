$resourceGroupName = "Reso"
$location = "EastUS"
Connect-AzAccount
New-AzResourceGroup -Name $resourceGroupName -Location $location
Write-Output "resource group '$resourceGroupName' created in Loaction '$location'"
