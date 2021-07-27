# ssam-mitigation
Script to remove the BUILTIN\Users ACL from C:\Windows\System32\config\SAM
Script adds output to a logfile for unattended use / checking for success

This is a modification of the existing script that changes inheritance of the sam file.
This removes the BUILTIN\User ACL ENTIRELY from the SAM file.

USE THIS AT YOUR OWN RISK

Notes:
Wildcard matching is using -like "'*BUILTIN\Users:*'" so it should match any ACL

I noticed "Get-WmiObject Win32_ShadowStorage -Property UsedSpace | Select-Object -ExpandProperty UsedSpace" was returning null instead of zero - if you have trouble with the script try changing the match for checking if shadow copy has been removed to "0" instead of "$null"
