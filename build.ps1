$ErrorActionPreference = "Stop"
Write-Host "NEXORA OS 0.1.0 — Docker ISO builder (Windows 11)" -ForegroundColor Red
Write-Host "Build only: your Windows installation is not modified by an OS installer."

if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw "Install and start Docker Desktop first, or use the GitHub Actions method instead."
}
docker info *> $null
if ($LASTEXITCODE -ne 0) {
    throw "Docker Desktop's Linux engine is not running."
}

$path = (Resolve-Path .).Path
New-Item -ItemType Directory -Force -Path (Join-Path $path "dist") | Out-Null

docker build -t nexora-os-builder:0.1.0 .
if ($LASTEXITCODE -ne 0) { throw "Docker builder image failed." }

docker run --rm --privileged `
    --mount "type=bind,source=$path,target=/work" `
    --workdir /work `
    nexora-os-builder:0.1.0 `
    bash /work/build.sh
if ($LASTEXITCODE -ne 0) { throw "ISO build failed. Read the output above." }

$iso = Join-Path $path "dist\NexoraOS-0.1.0-amd64.iso"
if (-not (Test-Path $iso)) {
    throw "Build completed but the expected ISO is missing."
}
Get-FileHash $iso -Algorithm SHA256
Write-Host "Created $iso" -ForegroundColor Green
