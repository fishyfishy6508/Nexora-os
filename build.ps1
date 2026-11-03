$ErrorActionPreference = 'Stop'
Write-Host 'Nexora OS 0.1.0 Beta — ISO Builder' -ForegroundColor Red
Write-Host 'Builds an ISO in Docker; does not install Linux onto Windows.'
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    throw 'Docker Desktop not found. Use GitHub Actions or install Docker Desktop.'
}
docker info *> $null
if ($LASTEXITCODE -ne 0) { throw 'Start Docker Desktop and wait for the engine.' }
$project = (Get-Location).Path
New-Item -ItemType Directory -Force -Path (Join-Path $project 'dist') | Out-Null

docker build -t nexora-os-builder:0.1.0 .
if ($LASTEXITCODE -ne 0) { throw 'Docker builder image failed.' }

docker run --rm --privileged `
  --mount "type=bind,source=$project,target=/work" `
  --workdir /work nexora-os-builder:0.1.0 bash /work/build.sh
if ($LASTEXITCODE -ne 0) { throw 'ISO build failed. Check the errors above.' }

$iso = Join-Path $project 'dist\NexoraOS-0.1.0-amd64.iso'
if (-not (Test-Path $iso)) { throw 'Expected ISO was not generated.' }
Get-FileHash -Algorithm SHA256 $iso
Write-Host "Done: $iso" -ForegroundColor Green
