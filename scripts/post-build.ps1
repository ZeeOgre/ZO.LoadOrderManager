param (
    [string]$configuration,
    [string]$msiFile = "..\Installer\ZO.LoadOrderManager.msi",
    [string]$versionFile = "..\Properties\version.txt",
    [bool]$manual = $false
)

function Execute-Command {
    param (
        [string]$command
    )
    Write-Output "Executing: $command"
    $result = Invoke-Expression $command 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Command failed: $command"
        Write-Error ($result -join "`n")
        exit 1
    }
    Write-Output $result
}

# Function to get the newest tag
function Get-NewestTag {
    $tags = git tag --sort=-v:refname
    Write-Output "Tags: $tags"
    return $tags[0]
}

# Function to increment a tag
function Increment-Tag {
    param (
        [string]$tag
    )
    if ($tag -match "-m(\d+)$") {
        $number = [long]$matches[1] + 1
        return $tag -replace "-m\d+$", "-m$number"
    } else {
        return "$tag-m1"
    }
}

# Check for changes before committing
$changes = git status --porcelain
if ($changes) {
    Execute-Command "git add -A"
    Execute-Command "git commit -m 'Post-build commit for configuration $configuration'"
} else {
    Write-Output "No changes to commit."
}

# Ensure correct directory
Set-Location $PSScriptRoot

# Debugging output
Write-Output "Current Directory: $(Get-Location)"
Write-Output "Configuration: $configuration"
Write-Output "MSI File: $msiFile"
Write-Output "Version File: $versionFile"
Write-Output "Manual Mode: $manual"

# Read version or set manual test tag
if (-not $manual) {
    $version = Get-Content $versionFile | Out-String
    $version = $version.Trim()
    $tagName = "v$version"
} else {
    $newestTag = Get-NewestTag
    Write-Output "Newest Tag: $newestTag"
    $tagName = Increment-Tag -tag $newestTag
    Write-Output "Incremented Tag: $tagName"
}

Write-Output "Tag Name: $tagName"

# Ensure on correct branch
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-Output "Current Branch: $currentBranch"

if ($currentBranch -eq 'master') {
    # Clobber down to dev
    Execute-Command "git checkout dev"
    Execute-Command "git merge -X theirs master"
    Write-Output "Merged master INTO dev with conflicts resolved in favor of master."
    $currentBranch = 'dev'
} elseif ($currentBranch -eq 'dev') {
    # Friendly merge up to master
    Execute-Command "git checkout master"
    Execute-Command "git merge dev"
    Write-Output "Merged dev INTO master."
    $currentBranch = 'master'
}

# Check if there are any changes before committing
$gitStatus = git status --porcelain
if (-not [string]::IsNullOrWhiteSpace($gitStatus)) {
    Execute-Command "git add ."
    Execute-Command "git commit -m 'Automated commit for $configuration configuration'"
    Write-Output "Committed changes."
}

# Check if the branch is ahead of the remote and push if necessary
$branchStatus = git status -uno
if ($branchStatus -match "Your branch is ahead of 'origin/$currentBranch'") {
    try {
        Execute-Command "git push origin $currentBranch"
        Write-Output "Pushed changes to $currentBranch."
    } catch {
        Write-Error "Failed to push changes to $currentBranch."
        Write-Error ($_.Exception.Message)
        exit 1
    }
} else {
    Write-Output "Nothing to commit, working tree clean."
}

# Handle release
if ($configuration -eq 'GitRelease') {
    Write-Output "Handling GitRelease configuration"
    
    # Delete existing local tag if it exists
    $existingTag = git tag -l $tagName
    if ($existingTag) {
        Write-Output "Deleting existing tag: $tagName"
        Execute-Command "git tag -d $tagName"
    }

    Write-Output "Creating new tag: $tagName"
    Execute-Command "git tag $tagName"
    Execute-Command "git push origin $tagName"
    Write-Output "Tagged and pushed release: $tagName"

    # Create GitHub release
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $autoUpdaterFile = "$(git rev-parse --show-toplevel)/Properties/AutoUpdater.xml"
        if (Test-Path -Path $autoUpdaterFile) {
            Write-Output "Creating GitHub release: $tagName"
            Execute-Command "gh release create $tagName $msiFile $autoUpdaterFile -t $tagName -n 'Release $tagName'"
            Write-Output "Created GitHub release: $tagName with AutoUpdater.xml"
        } else {
            Write-Error "AutoUpdater.xml file not found at path: $autoUpdaterFile"
            exit 1
        }
    } else {
        Write-Error "GitHub CLI (gh) not found."
        exit 1
    }

    # Check if there is a stash to pop
    $stashList = git stash list
    if (-not [string]::IsNullOrWhiteSpace($stashList)) {
        Write-Output "Popping stash"
        Execute-Command "git stash pop"
    } else {
        Write-Output "No stash to pop."
    }
}

# Push AutoUpdater.xml
$autoUpdaterFile = "$(git rev-parse --show-toplevel)/Properties/AutoUpdater.xml"
if (Test-Path -Path $autoUpdaterFile) {
    $autoUpdaterChanges = git status --porcelain $autoUpdaterFile
    if ($autoUpdaterChanges) {
        Write-Output "Committing changes to AutoUpdater.xml"
        Execute-Command "git add $autoUpdaterFile"
        Execute-Command "git commit -m 'Update AutoUpdater.xml for $tagName'"
        Execute-Command "git push origin $currentBranch"
        Write-Output "Pushed AutoUpdater.xml changes."
    } else {
        Write-Output "No changes to AutoUpdater.xml to commit."
    }
} else {
    Write-Error "AutoUpdater.xml file not found at path: $autoUpdaterFile"
    exit 1
}

# Check if GitHub CLI is available
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "GitHub CLI (gh) is not installed or not in PATH. Skipping release creation."
    exit 0
}

# Switch back to dev if needed
if ($currentBranch -eq 'dev') {
    Execute-Command "git checkout dev"
    Write-Output "Switched back to dev branch."
} else {
    # Ensure master is pushed
    Execute-Command "git push origin master"
    Write-Output "Pushed master branch."
}
