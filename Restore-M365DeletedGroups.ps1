############################################################################
# Restore-M365DeletedGroups.ps1
# Author : Sujin Nelladath
############################################################################

# Install Microsoft Graph module (if required)
Install-Module Microsoft.Graph -Force -Scope CurrentUser

# Connect to Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Prompt for group names
$GroupNames = Read-Host "Enter deleted group names (comma separated)"

# Convert to array and trim spaces
$GroupNamesArray = $GroupNames.Split(",") | ForEach-Object { $_.Trim() }

# Fetch all deleted groups once
$DeletedGroups = Get-MgDirectoryDeletedGroup -All

$SuccessCount = 0
$FailedCount = 0

foreach ($GroupName in $GroupNamesArray)
{
    Write-Host ""
    Write-Host "Searching for group: $GroupName" -ForegroundColor Cyan

    $MatchedGroups = $DeletedGroups | Where-Object {
        $_.DisplayName -eq $GroupName
    }

    if (!$MatchedGroups)
    {
        Write-Host "Group '$GroupName' not found in deleted items." -ForegroundColor Red
        $FailedCount++
        continue
    }

    foreach ($Group in $MatchedGroups)
    {
        # Determine Group Type
        if ($Group.GroupTypes -contains "Unified")
        {
            $GroupType = "Microsoft 365 Group"
        }
        elseif ($Group.SecurityEnabled)
        {
            $GroupType = "Security Group"
        }
        else
        {
            $GroupType = "Unknown"
        }

        # Display group details
        Write-Host ""
        Write-Host "Group Found:" -ForegroundColor Green
        Write-Host " Name      : $($Group.DisplayName)"
        Write-Host " Type      : $GroupType"
        Write-Host " Object Id : $($Group.Id)"

        try
        {
            Restore-MgDirectoryDeletedItem -DirectoryObjectId $Group.Id

            Write-Host " Successfully restored '$($Group.DisplayName)'" -ForegroundColor Green
            $SuccessCount++
        }
        catch
        {
            Write-Host " Failed to restore '$($Group.DisplayName)'" -ForegroundColor Yellow
            Write-Host " Error: $_"
            $FailedCount++
        }
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Restore Summary"
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Restored Successfully : $SuccessCount" -ForegroundColor Green
Write-Host "Failed                : $FailedCount" -ForegroundColor Red
