# Removes BUILTIN\User ACL from C:\Windows\System32\config\SAM
# v.09

# Script requires run as system
# Do not run on Windows Server if your backups use VSS

#Removes permissions and deletes shadow copies
$checkPermissions = icacls c:\Windows\System32\config\sam
if ($checkPermissions -like '*BUILTIN\Users:*') {
    icacls c:\windows\system32\config\sam /remove:g "BUILTIN\Users"
    vssadmin delete shadows /quiet /all
    $vulnerable = $true
}
else {
    $vulnerable = $false
}

 

#Checks if permissions have been removed
if ($vulnerable -eq $true) {
    $checkPermissions = icacls C:\windows\system32\config\sam
    if ($checkPermissions -like '*BUILTIN\Users:*') {
        $permissionsSucces = $false
        Add-Content -Path C:\samtest.log -Value "ACL change failed. Check permissions running script, e.g. run as SYSTEM."
    }
    else {
        $permissionsSucces = $true
        Add-Content -Path C:\samtest.log -Value "Successfully removed BUILTIN\Users ACL from SAM file."
    }
}

 

#Checks if shadow copies have been removed
if ($vulnerable -eq $true) {
    $checkShadow = Get-WmiObject Win32_ShadowStorage -Property UsedSpace | Select-Object -ExpandProperty UsedSpace
    if ($null -eq $checkShadow) {
        $shadowSucces = $true
        Add-Content -Path C:\samtest.log -Value "Successfully deleted old volume shadow copies."
    }
    else {
        $shadowSucces = $false
        Add-Content -Path C:\samtest.log -Value "Shadow deletion failed. Security software may be blocking this action or check running permissions."
    }
}

 

#Logic to determine script success
if ($vulnerable -eq $true) {
    if ($permissionsSucces -eq $true -and $shadowSucces -eq $true) {
        $fixed = $true
    }
    else {
        $fixed = $false
    }
}
else {
    $fixed = 'Not applicable'
}

 

#Creates new shadow copy
if ($vulnerable -eq $true -and $shadowSucces -eq $true -and $permissionsSucces -eq $true) {
    wmic shadowcopy call create Volume='C:\'
    Add-Content -Path C:\samtest.log -Value "Created New Shadow Copy"
}

 

#Outputs final script success to log file
Add-Content -Path C:\samtest.log -Value "vulnerable: $vulnerable"
Add-Content -Path C:\samtest.log -Value "Fixed: $fixed"
