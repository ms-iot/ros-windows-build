$ErrorActionPreference = 'Stop';

Write-Host 'Checking environment...'

# Check system PATH length
# https://support.microsoft.com/en-ca/help/830473/command-prompt-cmd-exe-command-line-string-limitation
$PathLen = $Env:PATH.Length
$MaxPathLen = 8191
if ($PathLen -gt $MaxPathLen) {
    Write-Warning "Windows has a path length limitation."
    Write-Warning "Your system path is quite long, which prevents ROS from installing or starting correctly."
    Write-Warning "Please reduce the size of your system path though the Windows System Advanced Control panel."
    throw "The length of %PATH% is over $MaxPathLen."
}

# Check git existence
$gitInstalled = Get-Command -ErrorAction SilentlyContinue git
if (-not $gitInstalled) {
    Write-Warning "To install ROS on this system, Git source control command line interface is required."
    Write-Warning "At the moment, it is not detected."
    Write-Warning "This is either because it hasn't been installed in a previous step, or this environment has not been updated to find it."
    Write-Warning "Please reinstall using 'choco install git -y' or if you have done that, restart this command window."
    throw "Git is not found."
}

Write-Host 'Checking environment... done.'
