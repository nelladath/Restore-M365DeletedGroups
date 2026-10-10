# Restore-M365DeletedGroups

Restore deleted Microsoft 365 Groups and Entra ID Security Groups in bulk using Microsoft Graph PowerShell. This script helps administrators quickly recover accidentally deleted groups from the Entra ID recycle bin by supporting bulk restoration, group type identification, validation, error handling, and detailed restoration reporting.

## Features

- Restore multiple deleted groups in a single execution
- Supports Microsoft 365 Groups
- Supports Entra ID Security Groups
- Displays group type before restoration
- Displays Object ID for verification
- Supports comma-separated group input
- Provides detailed success and failure reporting
- Uses Microsoft Graph PowerShell SDK
- Includes error handling for failed restore operations

## Supported Group Types

| Group Type | Supported |
| ---------- | --------- |
| Microsoft 365 Group | ✅ |
| Security Group | ✅ |
| Distribution Group | ❌ |

## Prerequisites

Before running this script, ensure the following requirements are met.

### Microsoft Graph PowerShell SDK

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

### Required Permissions

The script requires the following Microsoft Graph delegated permission:

```text
Group.ReadWrite.All
```

### Required Administrative Roles

One of the following Microsoft Entra roles is typically required:

- Global Administrator
- Groups Administrator
- User Administrator
- Intune Administrator
- Group Owner (for owned groups)

## How It Works

1. Connects to Microsoft Graph.
2. Retrieves all deleted groups from Microsoft Entra ID.
3. Accepts one or more group names as comma-separated input.
4. Searches the Entra ID deleted items container.
5. Identifies the group type.
6. Displays group details for verification.
7. Restores matching groups.
8. Generates a summary report showing successful and failed restorations.

## Installation

Clone the repository:

```powershell
git clone https://github.com/nelladath/Restore-M365DeletedGroups.git
```

Navigate to the repository folder:

```powershell
cd Restore-M365DeletedGroups
```

Install the Microsoft Graph PowerShell SDK if not already installed:

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

## Usage

Run the script:

```powershell
.\Restore-M365DeletedGroups.ps1
```

When prompted, enter one or more group names separated by commas:

```text
Finance Team, HR Team, Sales Team
```

## Example Output

```text
Searching for group: Finance Team

Group Found:
Name      : Finance Team
Type      : Microsoft 365 Group
Object Id : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Successfully restored 'Finance Team'

Searching for group: HR Team

Group Found:
Name      : HR Team
Type      : Security Group
Object Id : xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

Successfully restored 'HR Team'

=====================================
Restore Summary
=====================================

Restored Successfully : 2
Failed                : 0
```

## Permissions Consent

The script connects to Microsoft Graph using:

```powershell
Connect-MgGraph -Scopes "Group.ReadWrite.All"
```

You may be prompted to sign in and consent to the required permissions if they have not already been granted.

## Notes

- Deleted groups can only be restored during the Microsoft Entra ID soft-delete retention period.
- Permanently deleted groups cannot be recovered.
- Restoration includes group membership and associated group properties where supported.
- Group names are matched against the Display Name property.
- If multiple deleted groups share the same display name, all matching groups will be processed.

## Common Use Cases

### Accidental Group Deletion

Recover Microsoft 365 Groups or Security Groups that were accidentally deleted by an administrator.

### Bulk Recovery

Restore multiple groups after tenant cleanup activities or administrative mistakes.

### Migration Validation

Quickly recover groups removed during testing, pilot projects, or migration activities.

### Disaster Recovery

Assist in recovering collaboration and security groups during tenant recovery scenarios.

## Example Scenarios

### Restore a Single Group

Input:

```text
Finance Team
```

### Restore Multiple Groups

Input:

```text
Finance Team, HR Team, Sales Team
```

### Restore Mixed Group Types

Input:

```text
Finance Users, All Employees M365, IT Administrators
```

The script automatically identifies whether each group is a Microsoft 365 Group or a Security Group before restoration.

## Benefits

- Simplifies group recovery operations
- Eliminates manual restore tasks for multiple groups
- Provides visibility into group types before restoration
- Reduces administration time
- Supports Microsoft Graph modern authentication
- Produces clear success and failure reporting

## Author

**Sujin Nelladath**

- LinkedIn: [Sujin Nelladath](https://www.linkedin.com/in/sujin-nelladath-8911968a/)

## Contributing

Contributions, bug reports, feature requests, and suggestions are welcome.

If you would like to improve this script:

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Disclaimer

This script is provided as-is without warranty of any kind. Test thoroughly in a non-production environment before use. Always verify the groups identified for restoration before running the script in production.

## License

This project is licensed under the MIT License.

---
⭐ If you find this script useful, consider starring the repository and sharing it with the Microsoft 365 community.
