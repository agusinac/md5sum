## Powershell windows script equivalent to the linux `md5sum`.
## Finds files recursively given a md5 file.
## Tested on 17-02-2026
#----------------------------------------------------------------------------------------

param(
    [Alias("c")][string]$ChecksumFile = 'data.md5',
    [Alias("a")][ValidateSet('MD5', 'SHA1', 'SHA256', 'SHA512')][string]$Algorithm = 'MD5',
    [Alias("r")][string]$SearchRoot = '.',
    [Alias("q")][switch]$Quiet,
    [Alias("h")][switch]$Help  
)

if ($Help) {
    Write-Host @"
md5sum.ps1 with recursive search

USAGE:
    .\md5sum.ps1 [-c, -ChecksumFile] [-a, -Algorithm] [-r, -SearchRoot] [-q, -Quiet] [-h]

EXAMPLES:
    .\md5sum.ps1                           # Default: data.md5, MD5, current dir
    .\md5sum.ps1 -ChecksumFile data.md5 -SearchRoot C:\Downloads
    .\md5sum.ps1 -Quiet                    # Minimal output

PARAMETERS:
    -c, -ChecksumFile    Path to checksum file (default: data.md5) [REQUIRED]
    -a, -Algorithm       MD5|SHA1|SHA256|SHA512 (default: MD5)
    -r, -SearchRoot      Where to recursively search (default: '.')
    -q, -Quiet           Suppress debug output (only `OK/FAILED`)
    -h, -Help            Show this help

"@ -ForegroundColor Cyan
    exit 0
}

if (-not (Test-Path $ChecksumFile)) {
    Write-Error "Checksum file not found: $ChecksumFile"
    exit 1
}

if (-not $Quiet) {
    Write-Host "Verifying with algorithm: $Algorithm from root directory: $SearchRoot" -ForegroundColor Green
}

Write-Host "Starting verification with algo: $Algorithm" -ForegroundColor Green

Get-Content $ChecksumFile | ForEach-Object {
    $line = $_.Trim()
    # skip empty lines
    if ([string]::IsNullOrWhiteSpace($line)) { return }

    if (-not $Quiet) {
        Write-Host "Processing line: $line" -ForegroundColor Yellow
    }
    
    # Split "hash  filename"
    $parts = $line -split '\s+', 2
    $expected = $parts[0]
    $file = $parts[1]
    
    # Recursive find like 'find $searchRoot -name "$file"'
    $filePath = Get-ChildItem -Path $searchRoot -Recurse -Filter $file -ErrorAction SilentlyContinue | Select-Object -First 1 -Expand FullName

    if (-not $filePath) {
        if (-not $Quiet) { Write-Host "$file NOT FOUND" -ForegroundColor Red }
        return
    }

    $actual = (Get-FileHash -Algorithm $Algorithm -Path $filePath).Hash.ToLower()

    if (-not $Quiet) {
        Write-Host "  File: $file" -ForegroundColor Cyan
        Write-Host "  Expected hash: $expected" -ForegroundColor Cyan
        Write-Host "  Actual hash:   $actual" -ForegroundColor Magenta
    }

    if ($actual -eq $expected.ToLower()) {
        Write-Host "$file : OK" -ForegroundColor Green
    } else {
        Write-Host "$file : FAILED" -ForegroundColor Red
    }
    Write-Host ""
}
