$ErrorActionPreference = "Stop"

$dap = "$env:LOCALAPPDATA\nvim-data\site\pack\core\opt\nvim-dap"
$patch = "$env:LOCALAPPDATA\nvim\patches\nvim-dap-windows-breakpoints.patch"

Write-Host "Checking nvim-dap Windows breakpoint patch..."

git -C $dap apply --check $patch 2>$null

if ($LASTEXITCODE -eq 0) {
    git -C $dap apply $patch
    Write-Host "Applied nvim-dap Windows breakpoint patch."
}
else {
    $reverseCheck = git -C $dap apply --reverse --check $patch 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Patch is already applied."
    }
    else {
        Write-Warning "Patch no longer applies cleanly. nvim-dap may have changed upstream."
    }
}