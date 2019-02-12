Import-Module ActiveDirectory

#Enter a path to your import CSV file
$ADUsers = Import-CSV #"Enter CSV file path here"

foreach ($User in $ADUsers)
{
    $Username = $User.username
    $Password = $User.password 
    $Firstname = $User.firstname
    $Lastname = $User.lastname
    $OU = $User.ou

    #Check if user account already exists in AD
    if (Get-ADUser -F {SamAccountName -eq $Username})
    {
        #If user doesn't exist, output a warning message
        Write-Warning "A user account $Username already has an Active Directory Account."
    }
    else
    {
        #User doesn't exist, create a new user account
        #Account will be created in the OU listed in the $OU variable in the CSV file; don’t forget to change the domain name in the"-UserPrincipalName" variable
        New-ADUser `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@sl.lan" `
        -Name "$Firstname $Lastname" `
        -GivenName $Firstname `
        -Surname $Lastname `
        -Enabled $True `
        -ChangePasswordAtLogon $True `
        -DisplayName "$Firstname $Lastname" -Name "$Firstname $Lastname" ` 
        -EmailAddress "$Username@securelink.com"
        -Path $OU
        -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
    }
}


