$projects = @(
    "ign-cmake",
    "ign-math",
    "ign-msgs",
    "ign-tools",
    "ign-transport",
    "sdformat",
    "gazebo"
)

$projects_root = get-location

pushd "c:\opt\rosdeps\x64"

foreach ($project in $projects)
{
    $files = @()
    foreach($real_path in Get-Content $projects_root\$project\build\install_manifest.txt) {
        $relative_path = $(resolve-path -relative $real_path)
        $files += $relative_path.substring(2)
    }

    $project_drop = "$env:Build_ArtifactStagingDirectory\$project\"
    mkdir $project_drop

    $files | Set-Content $project_drop\list.txt
    7z a -spf $project_drop\bin.zip `@$project_drop\list.txt
}

popd
