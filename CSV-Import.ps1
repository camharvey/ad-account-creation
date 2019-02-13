Import-Module ActiveDirectory

#Enter a path to your import CSV file
$ADUsers = Import-CSV C:\Users\charvey\Desktop\user_import.csv


#Create User Accounts from CSV file
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
        #Account will be created in the OU listed in the $OU variable in the CSV file; edit domain name in "-UserPrincipalName" and address in "-EmailAddress"
        New-ADUser `
        -SamAccountName $Username `
        -UserPrincipalName "$Username@sl.lan" `
        -GivenName $Firstname `
        -Surname $Lastname `
        -Enabled $True `
        -ChangePasswordAtLogon $True `
        -DisplayName "$Firstname $Lastname" -Name "$Firstname $Lastname" `
        -EmailAddress "$Username@securelink.com" `
        -Path $OU `
        -AccountPassword (convertto-securestring $Password -AsPlainText -Force)
        #Add User to groups
        $Groups = @("SambaUsers","Austin","confluence-users","Google Apps","jira-users","Nexmark" )
        foreach ($Group in $Groups) { Add-ADPrincipalGroupMembership $Username -MemberOf $Group }
    }
}

#Assign SambaUsers as Primary Group
$group = Get-ADGroup "SambaUsers"
$groupSid = $group.sid
$groupSid
[int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)

foreach ($User in $ADUsers)
{ Set-ADUser $User.username -Replace @{primaryGroupID="$GroupID"} }