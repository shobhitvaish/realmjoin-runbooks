# This will create an export of your current set of Conditional Access policies to an Azure storage account
# 
# Permissions
# MS Graph: Policy.Read.All
# Azure: Access to the given Azure Storage Account / Resource Group

#Requires -Module @{ModuleName = "RealmJoin.RunbookHelper"; ModuleVersion = "0.5.1" }, Az.Storage

param(
    [string] $OrganizationId,
    [string] $ContainerName,
    [string] $ResourceGroupName,
    [string] $StorageAccountName,
    [string] $StorageAccountLocation,
    [string] $StorageAccountSKU 
)

try {
    Connect-RjRbGraph
    Connect-RjRbAzAccount

    if (-not $ContainerName) {
        $ContainerName = "conditional-policy-backup-" + (get-date -Format "yyyy-MM-dd")
    }

    #region configuration import
    # "Getting Process configuration URL"
    $processConfigURL = Get-AutomationVariable -name "SettingsSourceOrgPolicyExport" -ErrorAction SilentlyContinue
    if (-not $processConfigURL) {
        ## production default
        $processConfigURL = "https://raw.githubusercontent.com/realmjoin/realmjoin-runbooks/production/setup/defaults/settings-org-policies-export.json"
        ## staging default
        #$processConfigURL = "https://raw.githubusercontent.com/realmjoin/realmjoin-runbooks/master/setup/defaults/settings-org-policies-export.json"
    }
    # Write-RjRbDebug "Process Config URL is $($processConfigURL)"

    # "Getting Process configuration"
    $webResult = Invoke-WebRequest -UseBasicParsing -Uri $processConfigURL 
    $processConfig = $webResult.Content | ConvertFrom-Json

    if (-not $ResourceGroupName) {
        $ResourceGroupName = $processConfig.exportResourceGroupName
    }

    if (-not $StorageAccountName) {
        $StorageAccountName = $processConfig.exportStorAccountName
    }

    if (-not $StorageAccountLocation) {
        $StorageAccountLocation = $processConfig.exportStorAccountLocation
    }

    if (-not $StorageAccountSKU) {
        $StorageAccountSKU = $processConfig.exportStorAccountSKU
    }
    #endregion

    # Write a JSON file from a Policy / group description object
    function Export-PolicyObjects {
        param (
            [Parameter(Mandatory = $true)]
            [array]$policies
        )

        $policies | ForEach-Object {
            $name = $_.displayName -replace "[$([RegEx]::Escape([string][IO.Path]::GetInvalidFileNameChars()))]+", "_"
            if (-not (Test-Path ($name + ".json"))) {
                $_ | ConvertTo-Json -Depth 6 > ($name + ".json")
            }
            else {
                "Will not overwrite " + ($name + ".json") + ". Skipping."
            }
     
        }

    }

    # fetch the policies
    $pols = Invoke-RjRbRestMethodGraph -Resource "/identity/conditionalAccess/policies"

    # Write policy export as files
    mkdir "CAPols" | Out-Null
    $path = Set-Location -Path "CAPols"
    Export-PolicyObjects -policies $pols    

    # Make sure storage account exists
    $storAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -ErrorAction SilentlyContinue
    if (-not $storAccount) {
        "Creating Azure Storage Account $($StorageAccountName)"
        $storAccount = New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -Location $StorageAccountLocation -SkuName $StorageAccountSKU 
    }
    
    # Get access to the Storage Account
    $keys = Get-AzStorageAccountKey -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
    $context = New-AzStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $keys[0].Value

    # Make sure, container exists
    $container = Get-AzStorageContainer -Name $ContainerName -Context $context -ErrorAction SilentlyContinue
    if (-not $container) {
        "Creating Azure Storage Account Container $($ContainerName)"
        $container = New-AzStorageContainer -Name $ContainerName -Context $context 
    }
    
    # Upload
    $files = Get-ChildItem -Path $path
    $files | ForEach-Object {
        Set-AzStorageBlobContent -File $_.FullName -Container $ContainerName -Blob $_.Name -Context $context -Force | Out-Null
    }

    "Successfully created Conditional Access Export to"
    $container.CloudBlobContainer.Uri.AbsoluteUri | Out-String

}
finally {
    Disconnect-AzAccount -Confirm:$false | Out-Null
}