param(
    [switch]$Login,
    [switch]$ValidateBlueprint
)

$ErrorActionPreference = "Stop"

$projectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$envFile = Join-Path $projectRoot ".render.env.ps1"

if (Test-Path $envFile) {
    . $envFile
}

$renderCommand = Get-Command render -ErrorAction SilentlyContinue
$localRender = Join-Path $projectRoot "tools\render\cli_v2.19.0.exe"

if ($renderCommand) {
    $renderExe = $renderCommand.Source
} elseif (Test-Path $localRender) {
    $renderExe = $localRender
} else {
    Write-Host "Render CLI is not installed or is not on PATH."
    Write-Host "Install it from: https://render.com/docs/cli"
    exit 1
}

if ($Login) {
    & $renderExe login
    exit $LASTEXITCODE
}

if (-not $env:RENDER_API_KEY -or $env:RENDER_API_KEY -eq "rnd_your_render_api_key_here") {
    Write-Host "RENDER_API_KEY is not set."
    Write-Host "Copy .render.env.example.ps1 to .render.env.ps1 and add your Render API key, or run:"
    Write-Host "  .\scripts\render-check.ps1 -Login"
    exit 1
}

& $renderExe workspaces --output text --confirm
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

if ($ValidateBlueprint) {
    & $renderExe blueprints validate "$projectRoot\render.yaml" --output text --confirm
    exit $LASTEXITCODE
}
