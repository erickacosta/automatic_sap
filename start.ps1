#Script Start.ps1
#Author: erick.acosta@softtek.com
#Digital Office
#version 2.0

$SAPSID = $env:SAPSYSTEMNAME
$srvName = "OracleService"+$SAPSID
Write-Output $SAPSID "Starting script" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append

#Start Oracle DB
$timestamp = Get-Date -Format g
Write-Output $timestamp "ORA: Verifying status" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
do{
  $orastatus = Get-Service $srvName

  if($orastatus.Status -eq "Stopped"){
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "ORA: Stopped, proceeding to start service and database" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
    Start-Service -Name $srvName 
  }
  if($orastatus.Status -eq "Running"){
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "ORA: Running" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
  }
  if($orastatus.Status -eq "Starting"){
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "ORA: Starting, wait for 30 seconds" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
    Start-Sleep -Seconds 30
  }
} while ($orastatus.Status -ne "Running")

#Start SAP
$timestamp = Get-Date -Format g
Write-Output $timestamp "SAP: Verifying status" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
do{
  C:\"Program Files"\SAP\hostctrl\exe\sapcontrol.exe -nr 1 -function GetProcessList
  $sapstatus = $LASTEXITCODE

  if($sapstatus -ne 3){
    #Execute StartSystem for ALL instances in local server
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "SAP: Stopped, proceeding to start SAP" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
    C:\"Program Files"\SAP\hostctrl\exe\sapcontrol.exe -nr 1 -function StartSystem ALL 
    Start-Sleep -Seconds 30
  }
  else{
    $timestamp = Get-Date -Format g
    Write-Output $timestamp "SAP: Allready running" | Out-File "S:\usr\sap\DAA\SMDA98\script\start.log" -Append
  }
} while ($sapstatus -ne 3)