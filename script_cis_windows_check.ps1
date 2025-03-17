#Requires -RunAsAdministrator
#Requires -Version 4.0

chcp 1251

secedit /export /cfg ./secpool.cfg

Write-Host 'Начало проверки'

#Проверка парольной политики

$recomendation = "1.1.1 (L1) Параметр 'Журнал паролей' установлен на 24 или более сохраненных паролей» (автоматически)" + ";"
$result = Get-Content ./secpool.cfg | Select-String "PasswordHistorySize" | select-object -First 1

$recomendation += $result

$recomendation = $null
$result = $null