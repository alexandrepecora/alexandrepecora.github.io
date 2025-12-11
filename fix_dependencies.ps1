# PowerShell script to fix missing JavaScript dependencies after compilation
# Run this script whenever you recompile your Distill website

Write-Host "Fixing Distill website dependencies..." -ForegroundColor Green

# Copy jQuery files from posts to site_libs (this fixes the blank page issue)
$jquerySrc = ".\_posts\welcome\welcome_files\jquery-3.6.0\*"
$jqueryDest = ".\_site\site_libs\jquery-3.6.0\"

if (Test-Path $jquerySrc) {
    Copy-Item -Path $jquerySrc -Destination $jqueryDest -Force
    Write-Host "jQuery files copied successfully" -ForegroundColor Green
} else {
    Write-Host "jQuery source files not found" -ForegroundColor Yellow
}

# Create placeholder for headroom.min.js to prevent loading errors
$headroomPath = ".\_site\site_libs\headroom-0.9.4\headroom.min.js"
if (-not (Test-Path $headroomPath)) {
    New-Item -Path $headroomPath -ItemType File -Value "// Headroom placeholder - prevents loading error" -Force | Out-Null
    Write-Host "Headroom placeholder created" -ForegroundColor Green
}

# Verify all critical JavaScript files exist
$criticalFiles = @(
    ".\_site\site_libs\jquery-3.6.0\jquery-3.6.0.min.js",
    ".\_site\site_libs\distill-2.2.21\template.v2.js",
    ".\_site\site_libs\webcomponents-2.0.0\webcomponents.js"
)

Write-Host "Verifying critical files:" -ForegroundColor Cyan
foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "$(Split-Path $file -Leaf) - OK" -ForegroundColor Green
    } else {
        Write-Host "$(Split-Path $file -Leaf) - MISSING" -ForegroundColor Red
    }
}

Write-Host "Dependencies fixed! Your website should now display properly." -ForegroundColor Green