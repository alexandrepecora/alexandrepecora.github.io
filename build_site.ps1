# Build Distill Website Script
Write-Host "Building Distill website..." -ForegroundColor Green

# Set up environment variables
$env:RSTUDIO_PANDOC = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools"

# Run R compilation
$rPath = "C:/Users/alexpecora/AppData/Local/Programs/R/R-4.3.1/bin/R.exe"
$rCommand = "Sys.setenv(RSTUDIO_PANDOC='C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools'); rmarkdown::render_site()"

& $rPath -e $rCommand

if ($LASTEXITCODE -eq 0) {
    Write-Host "Website compilation completed successfully!" -ForegroundColor Green
    
    # Fix JavaScript dependencies
    Write-Host "Fixing dependencies..." -ForegroundColor Cyan
    .\fix_dependencies.ps1
    
} else {
    Write-Host "Compilation failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}