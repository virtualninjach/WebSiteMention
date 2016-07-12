$json = Get-Content -raw -path E:\Projects\WebSiteMention\config.json

$config = $json | ConvertFrom-Json

