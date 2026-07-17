# Build Distill Website Script
Write-Host "Building Distill website..." -ForegroundColor Green

# Set up environment variables
$env:RSTUDIO_PANDOC = "C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools"

# Run R compilation
# Desktop uses R-4.4.1. If running on the notebook, change this to R-4.3.1 instead.
$rPath = "C:/Users/alexpecora/AppData/Local/Programs/R/R-4.3.1/bin/R.exe"
$rCommand = "Sys.setenv(RSTUDIO_PANDOC='C:/Program Files/RStudio/resources/app/bin/quarto/bin/tools'); rmarkdown::render_site()"

& $rPath -e $rCommand

if ($LASTEXITCODE -eq 0) {
    Write-Host "Website compilation completed successfully!" -ForegroundColor Green

    # Fix JavaScript dependencies
    Write-Host "Fixing dependencies..." -ForegroundColor Cyan
    .\fix_dependencies.ps1

    # Deploy to GitHub Pages repo
    $siteSource = ".\_site\*"
    $ghPagesRepo = "C:/Users/alexpecora/OneDrive - Virginia Tech/Documents/GitHub/alexandrepecora.github.io"

    Write-Host "Copying site to GitHub Pages repo..." -ForegroundColor Cyan
    Copy-Item -Path $siteSource -Destination $ghPagesRepo -Recurse -Force

    # Inject Google Tag into index.html
    Write-Host "Injecting Google Analytics tag..." -ForegroundColor Cyan
    $indexPath = "$ghPagesRepo\index.html"
    $indexContent = Get-Content $indexPath -Raw
    $googleTag = @"
<script async src="https://www.googletagmanager.com/gtag/js?id=G-1W0R7B9CZM"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-1W0R7B9CZM');
</script>
"@
    if ($indexContent -notmatch "googletagmanager") {
        $indexContent = $indexContent -replace "<head>", "<head>`n$googleTag"
        Set-Content $indexPath $indexContent -NoNewline
        Write-Host "Google Tag injected successfully" -ForegroundColor Green
    } else {
        Write-Host "Google Tag already present, skipping injection" -ForegroundColor Yellow
    }

    Write-Host "Site ready! Open GitHub Desktop to review and push your changes." -ForegroundColor Green

} else {
    Write-Host "Compilation failed with exit code $LASTEXITCODE" -ForegroundColor Red
    exit $LASTEXITCODE
}