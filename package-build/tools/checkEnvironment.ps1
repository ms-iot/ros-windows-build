$ErrorActionPreference = 'Stop';

Write-Host 'Checking environment...'

# Check system PATH length
# https://support.microsoft.com/en-ca/help/830473/command-prompt-cmd-exe-command-line-string-limitation
$PathLen = $Env:PATH.Length
$MaxPathLen = 8191
if ($PathLen -gt $MaxPathLen) {
    Write-Warning "The length of %PATH% is over $MaxPathLen."
    Write-Warning "Reduce the %PATH% length and retry again."
    throw "The length of %PATH% is too long."
}

# Check git existence
$gitInstalled = Get-Command -ErrorAction SilentlyContinue git
if (-not $gitInstalled) {
    Write-Warning "Git is required to proceed."
    Write-Warning "Make sure Git is installed and retry again."
    throw "Git is not found."
}

Write-Host 'Checking environment... done.'
