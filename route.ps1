# Routes:
# 10.150.1.0/24         255.255.255.0   Office WiFi
# 192.168.114.1/24      255.255.255.0   Wired Office Network
# 192.168.0.0/16        255.255.0.0     Internal Company Network
# 172.16.0.0/12         255.240.0.0     Internal Company Network

# 192.168.xxx.0/24      255.255.255.0   Android Hotspot
# 192.168.10.0/24       255.255.255.0   Private Network

# IPs:
# 192.168.100.37        DNS Server 1
# 192.168.100.43        DNS Server 2
# 192.168.100.158       Proxy Server
# 192.168.100.22        Email Server

# Define custom routes

# Routes via office WiFi
$net_emp1 = "172.16.0.0"
$mask_emp1 = "255.240.0.0"
$metric_emp1 = 100
$net_emp2 = "192.168.0.0"
$mask_emp2 = "255.255.0.0"
$metric_emp2 = 100

$gateway_wifi = "10.150.1.1"

# Routes via Android network
$net_default = "0.0.0.0"
$mask_default = "0.0.0.0"
$metric_default = 50

$gateway_android = "192.168.170.1"

# Function to add a static route
function AddRoute {
    param (
        [string]$network,
        [string]$mask,
        [string]$gateway,
        [int]$metric
    )
    $network
    $mask
    $gateway
    route delete $network 2>$null 
    route add $network mask $mask $gateway metric $metric
}

# Function to delete a static route
function DeleteRoute {
    param (
        [string]$network,
        [string]$mask,
        [string]$gateway
    )
    route delete $network
}

# Show selection menu
Write-Host "Select an option:"
Write-Host "1. Activate custom routes - Office WiFi + Android via USB"
Write-Host "2. Default Configuration"

# Read user input
$choice = Read-Host "Enter the option number"

# Process the option
switch ($choice) {
    1 {
        AddRoute -network $net_emp1 -mask $mask_emp1 -gateway $gateway_wifi -metric $metric_emp1
        AddRoute -network $net_emp2 -mask $mask_emp2 -gateway $gateway_wifi -metric $metric_emp2

        AddRoute -network $net_default -mask $mask_default -gateway $gateway_android -metric $metric_default

        Write-Host "Static routes activated."
        route print -4 # Print the routing table
    }
    2 {
        DeleteRoute -network $net_emp1 -mask $mask_emp1 -gateway $gateway_wifi
        DeleteRoute -network $net_emp2 -mask $mask_emp2 -gateway $gateway_wifi

        AddRoute -network $net_default -mask $mask_default -gateway $gateway_wifi -metric $metric_default

        Write-Host "Static routes deactivated."
    }
    default {
        Write-Host "Invalid option. Select 1 or 2."
    }
}