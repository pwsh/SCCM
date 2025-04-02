if (!(Test-Path HKLM:\SOFTWARE\SCCMINVENTORY)) {new-item HKLM:\SOFTWARE\SCCMINVENTORY  -ErrorAction SilentlyContinue}
$perm = get-acl HKLM:\SOFTWARE\SCCMINVENTORY  -ErrorAction SilentlyContinue
$rule = New-Object System.Security.AccessControl.RegistryAccessRule("Authenticated Users","FullControl", "ContainerInherit, ObjectInherit", "InheritOnly", "Allow")  -ErrorAction SilentlyContinue
$perm.SetAccessRule($rule)
Set-Acl -Path HKLM:\SOFTWARE\SCCMINVENTORY $perm  -ErrorAction SilentlyContinue
if (!(Test-Path HKLM:\SOFTWARE\SCCMINVENTORY\NETWORKPRINTERS)) {new-item HKLM:\SOFTWARE\SCCMINVENTORY\NETWORKPRINTERS -ErrorAction SilentlyContinue}
if (!(Test-Path HKLM:\SOFTWARE\SCCMINVENTORY\MAPPEDDRIVES)) {new-item HKLM:\SOFTWARE\SCCMINVENTORY\MAPPEDDRIVES -ErrorAction SilentlyContinue}
