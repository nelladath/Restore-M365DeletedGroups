﻿##########################################################################

#Restore-M365DeletedGroups.ps1
#Author : Sujin Nelladath
#LinkedIn : https://www.linkedin.com/in/sujin-nelladath-8911968a/

############################################################################

# Install Microsoft Graph module
Install-Module Microsoft.Graph -Force -Scope CurrentUser


# Connect to Microsoft Graph with required scope
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Prompt user for group name
$GroupName = Read-Host "Enter the name of the Microsoft 365 group you want to restore"

# Fetch all deleted groups
$deletedGroups = Get-MgDirectoryDeletedGroup

# Find the group by display name
$targetGroup = $deletedGroups | Where-Object { $_.DisplayName -eq $GroupName }

if (!$targetGroup) 

    {
        Write-Host "Group '$GroupName' not found in deleted items." -ForegroundColor Red
    } 

else 
    {
        try 
            {
                Restore-MgDirectoryDeletedItem -DirectoryObjectId $targetGroup.Id
                Write-Host "Group '$GroupName' has been successfully restored." -ForegroundColor Green
            } 

        catch 

            {
                Write-Host "Failed to restore group '$GroupName'. Error: $_" -ForegroundColor Yellow
            }
     }