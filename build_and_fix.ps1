# Build Distill Website and Fix Dependencies Script
Write-Host "Building Distill website and fixing dependencies..." -ForegroundColor Green

# First, build the website
Write-Host "`n1. Compiling website..." -ForegroundColor Cyan
& ".\build_site.ps1"

if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed, stopping." -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "`n2. Fixing dependencies..." -ForegroundColor Cyan
& ".\fix_dependencies.ps1"

Write-Host "`n✓ Build and dependency fix complete!" -ForegroundColor Green
Write-Host "Your website is ready at: _site/index.html" -ForegroundColor White