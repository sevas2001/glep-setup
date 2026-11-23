# Guarda una variable en el .env del perfil de Hermes SIN pasar por el chat.
#   Secreto:  ./set-secret.ps1 -Profile glep -Name TELEGRAM_BOT_TOKEN      (abre un cuadro para pegarlo)
#   No secreto: ./set-secret.ps1 -Profile glep -Name TELEGRAM_ALLOWED_USERS -Plain 123456
param(
  [Parameter(Mandatory=$true)][string]$Profile,
  [Parameter(Mandatory=$true)][string]$Name,
  [string]$Plain
)
$ErrorActionPreference = "Stop"
$base = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:LOCALAPPDATA "hermes" }
$envFile = Join-Path $base "profiles\$Profile\.env"
if (-not (Test-Path $envFile)) { New-Item -ItemType File -Force -Path $envFile | Out-Null }
if ($PSBoundParameters.ContainsKey("Plain")) { $valor = $Plain }
else {
  Add-Type -AssemblyName Microsoft.VisualBasic
  $valor = [Microsoft.VisualBasic.Interaction]::InputBox("Pega el valor de $Name", "glep-setup", "")
}
if ([string]::IsNullOrWhiteSpace($valor)) { throw "Valor vacío, no se guarda nada." }
$lineas = @(Get-Content $envFile -Encoding UTF8 | ForEach-Object { $_.TrimStart([char]0xFEFF) } | Where-Object { $_ -notmatch "^\s*$Name=" })
$lineas += "$Name=$($valor.Trim())"
# UTF-8 SIN BOM (con BOM, la primera variable del .env quedaria corrupta)
[System.IO.File]::WriteAllText($envFile, (($lineas -join "`n") + "`n"), (New-Object System.Text.UTF8Encoding($false)))
Write-Host "$Name guardado en $envFile (valor no mostrado)."
