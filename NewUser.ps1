Import-Module ActiveDirectory


Write-Host "What is the user's first name?" -ForegroundColor Green
$Givenname = Read-Host  
Write-Host "What is the user's last name?" -ForegroundColor Green
$Surname = Read-Host
Write-Host "Please enter the username for this user" -ForegroundColor Green 
$User = Read-Host
Write-Host "Please enter the user password for this user" -ForegroundColor Green
$Password = Read-Host -AsSecureString

$Email = "$User@domain.com" #Enter your domain for email address
$OU = "Path" #Enter your AD path for your organization

New-ADUser -SamAccountName $User `
-AccountPassword $Password `
-UserPrincipalName "$User@sl.lan" `
-GivenName $Givenname -Surname $Surname `
-EmailAddress $Email -Enabled $true `
-ChangePasswordAtLogon $true `
-DisplayName "$Givenname $Surname" -Name "$Givenname $Surname" `
-Path $OU
