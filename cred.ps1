# Parameters
$resourceGroupName = "asasasas" # Change this to your resource group name
$location = "EastUS" # Change this to your desired location
$vmName = "MyVMMyVM" # Change this to your desired VM name
$vmSize = "Standard_DS1_v2" # Change this to your desired VM size
$adminUsername = "azureuser" # Change this to your desired admin username
$adminPassword = "Password@123!" # Change this to a secure password
$imagePublisher = "MicrosoftWindowsServer" # Publisher for Windows Server
$imageOffer = "WindowsServer" # Offer for Windows Server
$imageSku = "2019-Datacenter" # SKU for Windows Server 2019
$subnetConfig = Add-AzVirtualNetworkSubnetConfig # -Name "MySubnet" -VirtualNetwork $virtualNetwork -AddressPrefix "10.0.1.0/24"

# Create a resource group if it doesn't exist
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a virtual network
$virtualNetwork = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location `
    -Name "MyVNet" -AddressPrefix "10.0.0.0/16"

# Create a subnet
$subnetConfig = Add-AzVirtualNetworkSubnetConfig -Name "MySubnet" `
    -AddressPrefix "10.0.1.0/24" -VirtualNetwork $virtualNetwork

# Create the virtual network
$virtualNetwork | Set-AzVirtualNetwork

# Create a public IP address
$publicIp = New-AzPublicIpAddress -ResourceGroupName $resourceGroupName -Location $location `
    -Name "MyPublicIP" -Sku "Standard" -AllocationMethod "Static"

# Create a network security group (NSG)
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location `
    -Name "MyNetworkSecurityGroup"

# Create a rule to allow RDP (port 3389)
$rdpRule = Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name "Allow-RDP" `
    -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix * `
    -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 3389 -Access Allow

# Create a network interface
$nic = New-AzNetworkInterface -ResourceGroupName $resourceGroupName -Location $location `
    -Name "MyNIC" -PublicIpAddress $publicIp -NetworkSecurityGroup $nsg `
    -Subnet $subnetConfig

# Create the virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize $vmSize `
    -Credential (New-Object System.Management.Automation.PSCredential($adminUsername, `
    (ConvertTo-SecureString $adminPassword -AsPlainText -Force))) `
    -ImageName "$imagePublisher/$imageOffer/$imageSku" `
    -Location $location

# Add the network interface to the VM configuration
$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $nic.Id

# Create the virtual machine
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

Write-Host "Virtual Machine '$vmName' created successfully in resource group '$resourceGroupName'."