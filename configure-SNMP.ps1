######################################################################################################
# Description   :- Powershell Script To Install SNMP Services (SNMP Service, SNMP WMI Provider)
# Author        :- Muhammed Iqbal - Meraas IT
# Created       :- 15-Aug-2019
# Updated       :- 15-Aug-2019
# Version       :- 0.1
# License       :- MIT
# Notes         :- 
#####################################################################################################

#Requires -RunAsAdministrator

$MonitoringNode = "" # Your SNMP Monioring Node (IP or DNS name) 
$CommunityString = "" # Your community string configured with Monitoring node.


# Configure SNMP service
function configure_SNMP {
  
  Write-Host "Configuring SNMP-Services with your Community string and Monitoring Node"
  
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 1 /t REG_SZ /d localhost /f | Out-Null
  Write-Host "Configuration of PermittedManger localhost: Done!"
  
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\PermittedManagers" /v 2 /t REG_SZ /d $MonitoringNode /f | Out-Null
  Write-Host "Configuration of PermittedManger $MonitoringNode : Done!"
  
  reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SNMP\Parameters\ValidCommunities" /v $CommunityString /t REG_DWORD /d 4 /f | Out-Null
  Write-Host "Configuration of Community String - $CommunityString : Done!"
  
}


Import-Module ServerManager

# Check if SNMP-Service Feature is enabled
$snmp_stat = Get-WindowsFeature -Name SNMP-Service

# Install/Enable SNMP-Service 
If ($snmp_stat.Installed -ne "True") {
 
  Write-Host “Enabling SNMP-Service Feature”
  Get-WindowsFeature -name SNMP* | Add-WindowsFeature -IncludeManagementTools | Out-Null

  configure_SNMP $MonitoringNode $CommunityString

}
ElseIf ($snmp_stat.Installed -eq “True”) {

  Write-Host "SNMP Services Already Installed"
  configure_SNMP $MonitoringNode $CommunityString

}
Else {

  Write-Host "SNMP Configuration Failed.!"

}
