<# 

Written By Eric Holzhueter with no implied guarantee it will work

This does not check for prerequisites, specifically the following note from MS

    Important Note: For systems running Windows 7 SP1 or Windows Server 2008 R2 SP1, you’ll need WMF 4.0 and .NET Framework 4.5 or higher installed to run WMF 5.0.

It also does not cleanup the file when done. Some might want this.

WMF 5.0 download page
    https://www.microsoft.com/en-us/download/details.aspx?id=50395

WMF Blog posts 
    https://blogs.msdn.microsoft.com/powershell/2015/12/16/windows-management-framework-wmf-5-0-rtm-is-now-available/
    https://blogs.msdn.microsoft.com/powershell/2016/02/24/windows-management-framework-wmf-5-0-rtm-packages-has-been-republished/

OS version table https://msdn.microsoft.com/en-us/library/windows/desktop/ms724832%28v=vs.85%29.aspx

#>

#Get the operating environment
$Arch = (Get-WmiObject -Class Win32_Processor).addresswidth
$OS = (Get-WmiObject Win32_OperatingSystem).version.split('.')[0]
$OSMinor = (Get-WmiObject Win32_OperatingSystem).version.split('.')[1]

#64 bit OS check
if($Arch -eq 64){
    if($OS -eq 6 -and $OSMinor -eq 1){$url = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7AndW2K8R2-KB3134760-x64.msu"
                                      $file = "Win7AndW2K8R2-KB3134760-x64.msu"}
    if($OS -eq 6 -and $OSMinor -eq 2){$url = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3134759-x64.msu"
                                      $file = "W2K12-KB3134759-x64.msu"}
    if($OS -eq 6 -and $OSMinor -eq 3){$url = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1AndW2K12R2-KB3134758-x64.msu"
                                      $File = "Win8.1AndW2K12R2-KB3134758-x64.msu"}
}
elseif($Arch -eq 32){
    if($OS -eq 6 -and $OSMinor -eq 1){$url = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3134760-x86.msu"
                                      $file = "Win7-KB3134760-x86.msu"}
    if($OS -eq 8 -and $OSMinor -eq 3){$url = "https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3134758-x86.msu"
                                      $file = "Win8.1-KB3134758-x86.msu"}
}

if($url -eq $null -or $file -eq $null){Write-Error "Failed to find valid OS"}
Else{
    $output = Join-Path $env:TEMP $file

    Write-Output "Downloading: $file"
    Write-Output "From: $url"
    Write-Output "To: $output"

    $wc = New-Object System.Net.Webclient
    #May be required in some places with authenticated proxy
    #$wc.UseDefaultCredentials = $true
    #$wc.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")
    $wc.DownloadFile($url, $output)

    if(test-path $output){ Write-Output "Installing $file"
                           & wusa $output /quiet /norestart}
    else{Write-Warning "File $((Join-Path $output $file)) does not exist"}
}
