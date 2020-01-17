
$Path = "D:\ExpiringCertificates-Monitoring.log"

$certs = Get-ChildItem CERT:LocalMachine -Recurse |
  Where-Object { $null -ne $_.NotAfter } |
  Where-Object { $null -ne $_.DnsNameList } 
 
$list = $certs | Sort-Object NotAfter | 
Select-Object @{Name = "ComputerName"; Expression = { $_.PSComputerName } },
@{Name = "FileName"; Expression = { "" } },
@{Name = "ValidTo"; Expression = { $_.NotAfter.ToShortDateString() } }, 
@{Name = "ValidFrom"; Expression = { $_.NotBefore.ToShortDateString() } },
Issuer, 
@{Name = "DnsName"; Expression = { $_.DnsNameList.Unicode } } 

$list | Export-Csv -Delimiter '|' -NoTypeInformation -Path "$Path+header"
 
(Get-Content "$Path+header" | Select-Object -Skip 1) | Set-Content $Path 
