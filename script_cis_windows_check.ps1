#Requires -RunAsAdministrator
#Requires -Version 4.0

secedit /export /cfg ./secpool.cfg

$recommendationsFile = "./cis_recomendations.json"
$recommendations = Get-Content -Path $recommendationsFile | ConvertFrom-Json

$results = @()


foreach ($recommendation in $recommendations) {
    $currentValue = $null
    $status = "Unknown"

    # Проверка типа рекомендации (например, реестр)
    if ($recommendation.Type -eq "Registry") {
        # Получаем текущее значение из реестра
        $currentValue = Get-ItemProperty -Path $recommendation.Path -Name $recommendation.Key -ErrorAction SilentlyContinue

        if ($currentValue -eq $null) {
            $status = "Key not found"
        } elseif ($currentValue.$($recommendation.Key) -eq $recommendation.ExpectedValue) {
            $status = "Compliant"
        } else {
            $status = "Non-Compliant"
        }
    }

    # Добавляем результат в массив
    $results += [PSCustomObject]@{
        Description = $recommendation.Description
        Path        = $recommendation.Path
        Key         = $recommendation.Key
        Expected    = $recommendation.ExpectedValue
        Current     = if ($currentValue -eq $null) { "N/A" } else { $currentValue.$($recommendation.Key) }
        Status      = $status
    }
}

# Вывод результатов
$results | Format-Table -AutoSize

$result_file = "audit" + $date + "-Win" + ".csv"

# Сохранение результатов в файл (опционально)
$results | Export-Csv -Path $result_file -NoTypeInformation



# chcp 1251

# secedit /export /cfg ./secpool.cfg

# #Get the date
# $Date = Get-Date -U %d%m%Y



# Write-Host 'Start checkout'

# #проверка check

# #$recomendation = "1.1.1 (L1) ÐŸÐ°Ñ€Ð°Ð¼ÐµÑ‚Ñ€ 'Ð–ÑƒÑ€Ð½Ð°Ð» Ð¿Ð°Ñ€Ð¾Ð»ÐµÐ¹' ÑƒÑ�Ñ‚Ð°Ð½Ð¾Ð²Ð»ÐµÐ½ Ð½Ð° 24 Ð¸Ð»Ð¸ Ð±Ð¾Ð»ÐµÐµ Ñ�Ð¾Ñ…Ñ€Ð°Ð½ÐµÐ½Ð½Ñ‹Ñ… Ð¿Ð°Ñ€Ð¾Ð»ÐµÐ¹Â» (Ð°Ð²Ñ‚Ð¾Ð¼Ð°Ñ‚Ð¸Ñ‡ÐµÑ�ÐºÐ¸)" + ";"
# $recomendation = "1.1.1 (L1) Ensure 'Enforce password history' is set to '24 or more
# password(s)' (Automated)" + ";"
# $result = Get-Content ./secpool.cfg | Select-String "PasswordHistorySize" | select-object -First 1

# $recomendation += $result
# $recomendation >> $result_file

# $recomendation = $null
# $result = $null