# Instala Hermes Agent en Windows (nativo).
$ErrorActionPreference = "Stop"
if (Get-Command hermes -ErrorAction SilentlyContinue) {
  Write-Host "Hermes ya está instalado:"; hermes --version; exit 0
}
iex (irm https://hermes-agent.nousresearch.com/install.ps1)
Write-Host "Cierra y abre la terminal, luego comprueba: hermes --version"
