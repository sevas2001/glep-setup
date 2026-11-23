param(
  [string]$Profile = "glep",
  [Parameter(Mandatory=$true)][string]$VaultPath
)
$base = if ($env:HERMES_HOME) { $env:HERMES_HOME } else { Join-Path $env:LOCALAPPDATA "hermes" }
$pdir = Join-Path $base "profiles\$Profile"
$envFile = Join-Path $pdir ".env"
$ok = $true
function Check($nombre, $cond) {
  if ($cond) { Write-Host "[OK]   $nombre" } else { Write-Host "[FALLA] $nombre"; $script:ok = $false }
}
function TieneVar($n) { (Test-Path $envFile) -and ((Get-Content $envFile -Encoding UTF8) -match "^\s*$n=.+") }

Check "hermes instalado" ([bool](Get-Command hermes -ErrorAction SilentlyContinue))
Check "perfil $Profile existe" (Test-Path $pdir)
Check "SOUL.md del perfil" (Test-Path (Join-Path $pdir "SOUL.md"))
Check "vault con GLEP.md" (Test-Path (Join-Path $VaultPath "GLEP.md"))
Check "vault es repo git" (Test-Path (Join-Path $VaultPath ".git"))
Check "ToDoApp (tareas.json + build.py)" ((Test-Path (Join-Path $VaultPath "02-Proyectos\gestor-tareas\tareas.json")) -and (Test-Path (Join-Path $VaultPath "02-Proyectos\gestor-tareas\build.py")))
Check "OBSIDIAN_VAULT_PATH en .env" (TieneVar "OBSIDIAN_VAULT_PATH")
Check "TELEGRAM_BOT_TOKEN en .env" (TieneVar "TELEGRAM_BOT_TOKEN")
Check "TELEGRAM_ALLOWED_USERS en .env" (TieneVar "TELEGRAM_ALLOWED_USERS")
# validar token sin mostrarlo
if (TieneVar "TELEGRAM_BOT_TOKEN") {
  $tok = ((Get-Content $envFile -Encoding UTF8) -match "^\s*TELEGRAM_BOT_TOKEN=") -replace "^\s*TELEGRAM_BOT_TOKEN=", ""
  try { $r = Invoke-WebRequest -UseBasicParsing "https://api.telegram.org/bot$($tok[0])/getMe"; Check "token de Telegram válido (getMe)" ($r.StatusCode -eq 200) }
  catch { Check "token de Telegram válido (getMe)" $false }
}
Write-Host "--- gateway ---"; hermes gateway status
Write-Host "--- opcional voz ---"
Write-Host ("GROQ_API_KEY: " + (TieneVar "GROQ_API_KEY")); Write-Host ("CARTESIA_API_KEY: " + (TieneVar "CARTESIA_API_KEY"))
if ($ok) { Write-Host "Todo listo: escribe a tu bot en Telegram." } else { Write-Host "Hay fallos: revisa docs/troubleshooting.md"; exit 1 }
