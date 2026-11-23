param(
  [Parameter(Mandatory=$true)][string]$VaultPath,
  [string]$UserName = "usuario"
)
$ErrorActionPreference = "Stop"
$src = Join-Path (Split-Path $PSScriptRoot -Parent) "vault-template"
if ((Test-Path $VaultPath) -and (Get-ChildItem $VaultPath -Force | Select-Object -First 1)) {
  throw "La carpeta $VaultPath ya existe y no está vacía. Elige otra o vacíala."
}
New-Item -ItemType Directory -Force -Path $VaultPath | Out-Null
Copy-Item -Path (Join-Path $src "*") -Destination $VaultPath -Recurse -Force
Copy-Item -Path (Join-Path $src ".gitignore") -Destination $VaultPath -Force
$hoy = Get-Date -Format "yyyy-MM-dd"
Get-ChildItem $VaultPath -Recurse -Filter *.md | ForEach-Object {
  (Get-Content $_.FullName -Raw -Encoding UTF8).Replace("AAAA-MM-DD", $hoy) | Set-Content $_.FullName -Encoding UTF8
}
git -C $VaultPath init -q
git -C $VaultPath add -A
git -C $VaultPath commit -q -m "Vault inicial"
Write-Host "Vault creado en $VaultPath. Ábrelo en Obsidian con 'Abrir una carpeta como bóveda'."
