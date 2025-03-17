#Requires -RunAsAdministrator
#Requires -Version 4.0

chcp 65001

secedit /export /cfg ./secpool.cfg

#Get the date
$Date = Get-Date -U %d%m%Y

$result_file = "audit" + $date + "-" + $Win +".txt"

Write-Host 'Начало проверки'

#Проверка парольной политики

$recomendation = "1.1.1 (L1) Параметр 'Журнал паролей' установлен на 24 или более сохраненных паролей» (автоматически)" + ";"
$result = Get-Content ./secpool.cfg | Select-String "PasswordHistorySize" | select-object -First 1

$recomendation += $result
$recomendation >> $result_file

$recomendation = $null
$result = $null