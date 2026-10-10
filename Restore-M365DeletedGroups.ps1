############################################################################
# Restore-M365DeletedGroups.ps1

# Author : Sujin Nelladath

#Restore deleted Microsoft 365 Groups and Entra ID Security Groups in bulk using Microsoft Graph PowerShell. 
#This script helps administrators quickly recover accidentally deleted groups from the Entra ID recycle bin by supporting bulk restoration, group type identification, validation, error handling, and detailed restoration reporting.

############################################################################

# Install Microsoft Graph module (if required)

Install-Module Microsoft.Graph -Force -Scope CurrentUser

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Prompt user
$GroupNames = Read-Host "Enter deleted group names (comma separated)"

# Convert to array
$GroupNamesArray = $GroupNames.Split(",") | ForEach-Object { $_.Trim() }

Write-Host "Retrieving deleted groups..." -ForegroundColor Cyan

# Retrieve all deleted groups with pagination
$DeletedGroups = @()

$Uri = "https://graph.microsoft.com/v1.0/directory/deletedItems/microsoft.graph.group?`$select=id,displayName,groupTypes,securityEnabled"

do {
    $Response = Invoke-MgGraphRequest -Method GET -Uri $Uri

    if ($Response.value) {
        $DeletedGroups += $Response.value
    }

    $Uri = $Response.'@odata.nextLink'

} while ($Uri)

Write-Host "Found $($DeletedGroups.Count) deleted groups." -ForegroundColor Green

$SuccessCount = 0
$FailedCount = 0

foreach ($GroupName in $GroupNamesArray)
{
    Write-Host ""
    Write-Host "Searching for group: $GroupName" -ForegroundColor Cyan

    $MatchedGroups = $DeletedGroups | Where-Object {
        $_.displayName -eq $GroupName
    }

    if (-not $MatchedGroups)
    {
        Write-Host "Group '$GroupName' not found in deleted items." -ForegroundColor Red
        $FailedCount++
        continue
    }

    foreach ($Group in $MatchedGroups)
    {
        # Determine group type

        if ($Group.groupTypes -contains "Unified")
        {
            $GroupType = "Microsoft 365 Group"
        }
        elseif ($Group.securityEnabled -eq $true)
        {
            $GroupType = "Security Group"
        }
        else
        {
            $GroupType = "Unknown"
        }

        Write-Host ""
        Write-Host "Group Found:" -ForegroundColor Green
        Write-Host " Name      : $($Group.displayName)"
        Write-Host " Type      : $GroupType"
        Write-Host " Object Id : $($Group.id)"

        try
        {
            Invoke-MgGraphRequest `
                -Method POST `
                -Uri "https://graph.microsoft.com/v1.0/directory/deletedItems/$($Group.id)/restore"

            Write-Host "Successfully restored '$($Group.displayName)'" -ForegroundColor Green

            $SuccessCount++
        }
        catch
        {
            Write-Host "Failed to restore '$($Group.displayName)'" -ForegroundColor Red
            Write-Host "Reason: $($_.Exception.Message)" -ForegroundColor Yellow

            $FailedCount++
        }
    }
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Restore Summary" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "Restored Successfully : $SuccessCount" -ForegroundColor Green
Write-Host "Failed                : $FailedCount" -ForegroundColor Red
