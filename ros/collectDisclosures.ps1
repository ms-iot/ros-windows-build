Param 
(
    $Path= '.\',
    $FileName= @("*_LICENSE.txt", "LICENSE", "LICENSE.md", "License.txt", "copyright.txt"),
    $outputfile= ".\License.txt"
)

Function Get-FileContent 
{
    Param 
    (
        $Path= '.\',
        $FileNames= @("*_LICENSE.txt", "LICENSE", "LICENSE.md", "License.txt", "copyright.txt"),
        $outputfile= ".\License.txt"
    )

    $seenLicenseFileHashes = @()
 
    Get-ChildItem -Path $Path -Include $FileNames -Recurse | ForEach-Object {
        $hash = Get-FileHash $_
        if (!$seenLicenseFileHashes.Contains($hash.Hash))
        {
            $seenLicenseFileHashes += $hash.Hash
            $_.FullName >> $outputfile
            Get-Content $_ >> $outputfile
        }
    }
}
    
Get-FileContent -Path $Path -FileName $FileName -outputfile $outputfile
