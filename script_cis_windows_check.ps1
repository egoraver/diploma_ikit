#Requires -RunAsAdministrator
#Requires -Version 4.0

chcp 1251

secedit /export /cfg ./secpool.cfg

#Get the date
$Date = Get-Date -U %d%m%Y

$result_file = "audit" + $date + "-Win" + ".txt"

Write-Host 'Start checkout'

#Проверка парольной политики

#$recomendation = "1.1.1 (L1) Параметр 'Журнал паролей' установлен на 24 или более сохраненных паролей» (автоматически)" + ";"
$recomendation = "1.1.1 (L1) Ensure 'Enforce password history' is set to '24 or more
password(s)' (Automated)" + ";"
$result = Get-Content ./secpool.cfg | Select-String "PasswordHistorySize" | select-object -First 1

$recomendation += $result
$recomendation >> $result_file

$recomendation = $null
$result = $null