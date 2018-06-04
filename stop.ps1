#Script Stop.ps1
#Author: erick.acosta@softtek.com
#Digital Office
#version 2.0

$SAPSID = $env:SAPSYSTEMNAME
$srvName = "OracleService"+$SAPSID
Write-Output $SAPSID "Starting script" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append

#Shutdown SAP before stop db
$timestamp = Get-Date -Format g
Write-Output $timestamp "SAP: Verifying status" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
do{
  C:\"Program Files"\SAP\hostctrl\exe\sapcontrol.exe -nr 1 -function GetProcessList
  $sapstatus = $LASTEXITCODE

  if($sapstatus -ne 4){
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "SAP: Running, proceeding to stop all SAP instances" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
    C:\"Program Files"\SAP\hostctrl\exe\sapcontrol.exe -nr 1 -function StopSystem ALL 
    Start-Sleep -Seconds 30
  }
  else{
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "SAP: Stopped" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
  }
} while ($sapstatus -ne 4)

#Stop Oracle DB by shutting down OracleService 
$timestamp = Get-Date -Format g
Write-Output $timestamp "ORA: Verifying status" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
do{
  $orastatus = Get-Service $srvName

  if($orastatus.Status -ne "Stopped"){
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "ORA: Running, proceeding to stop service and shutdown database" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
    Stop-Service -Name $srvName -Force
  }
  else{
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "ORA: Stopped" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
  }
 } while ($orastatus.Status -ne "Stopped")

#Shutdown Server
$timestamp = Get-Date -Format g
Write-Output $timestamp "WIN: Shutdown Server" | Out-File "S:\usr\sap\DAA\SMDA98\script\stop.log" -Append
Stop-Computer -Force 