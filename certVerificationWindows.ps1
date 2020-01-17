
$Path = "D:\PaymentService\Logs\ExpiringCertificates-Monitoring.log"

$certs = Get-ChildItem CERT:LocalMachine -Recurse |
  Where-Object { $null -ne $_.NotAfter } |
  Where-Object { $null -ne $_.DnsNameList } 


$list = $certs | Sort-Object NotAfter | 
Select-Object @{Name = "ValidTo"; Expression = { $_.NotAfter.ToShortDateString() } }, 
@{Name = "ValidFrom"; Expression = { $_.NotBefore.ToShortDateString() } },
@{Name = "ComputerName"; Expression = { $_.PSComputerName } },
Issuer, 
@{Name = "DnsName"; Expression = { $_.DnsNameList.Unicode } } 

Clear-Content $Path

Foreach ($v in $list) {
  ($v | ConvertTo-Json).Replace("`n", '') | Out-File -Append $Path
} 
 
