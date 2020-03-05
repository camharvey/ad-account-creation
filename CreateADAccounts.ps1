<#

.SYNOPSIS
This Powershell script is used to create AD Users from either a CSV file, a hashtable object, or through the CLI

.DESCRIPTION
The CSVFileName flag checks for the file path of an existing CSV file. The NewUser flag checks and creates a user based on the hashtable.
The other flags are used to create a basic AD User based off a pre-existing template. If no flags are included, the script will prompt for the user's
first name, last name, password, card number and card PIN. 

.EXAMPLE
./Create-ADAccount.ps1

.NOTES
These are some notes. Please show up.


#>

function Do-Something{
### Set Parameters   
    [CmdletBinding(DefaultParameterSetName = 'New User')]
    param (
        [Parameter (ParameterSetName = 'CSV')]
        $CSVFileName,

        [Parameter (ParameterSetName = 'UserHash',             
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$True)]
        [hashtable]$UserHash,
        
        [Parameter (Mandatory = $True,ParameterSetName = 'New User')]
        [Parameter (Mandatory = $False,ParameterSetName = 'CSV')]
        [Parameter (Mandatory = $False,ParameterSetName = 'UserHash')]
        [string]$FirstName,
        
        [Parameter (Mandatory = $True,ParameterSetName = 'New User')]
        [Parameter (Mandatory = $False,ParameterSetName = 'CSV')]
        [Parameter (Mandatory = $False,ParameterSetName = 'UserHash')]
        [string]$LastName,

        # [Parameter (Mandatory = $True,ParameterSetName = 'New User')]
        # [Parameter (Mandatory = $False,ParameterSetName = 'CSV')]
        # [Parameter (Mandatory = $False,ParameterSetName = 'UserHash')]
        #$Password,

        [Parameter (Mandatory = $True,ParameterSetName = 'New User')]
        [Parameter (Mandatory = $False,ParameterSetName = 'CSV')]
        [Parameter (Mandatory = $False,ParameterSetName = 'UserHash')]
        [int]$CardNumber,

        [Parameter (Mandatory = $True,ParameterSetName = 'New User')]
        [Parameter (Mandatory = $False,ParameterSetName = 'CSV')]
        [Parameter (Mandatory = $False,ParameterSetName = 'UserHash')]
        [int]$CardPIN

    )
### Start BEGIN Block
    BEGIN {
        Import-Module ActiveDirectory

    }
### Start PROCESS Block
    PROCESS {
        Write-Host -ForegroundColor Cyan "Checking for a CSV File for input"
        ### Checking for AD User CSV File
        #if ($CSVFileName -eq $null) {
        #    Write-Host "There is no CSV file."
        #}
        #else {
        if ($CSVFileName -ne $null) {
            Try {
                if (-not (Test-Path -Path $CSVFileName)) {
                    throw
                }
                else {
                    CSV-FileCheck
                }
            } 
            Catch {
               Write-Host "$CSVFileName cannot be found."
            }
        }
        Write-Host -ForegroundColor Cyan "Finishing Check for CSV File"
        Write-Host -ForegroundColor Cyan "Checking for AD User Hashtable"
        ### Checking for AD User hashtable
        if ($UserHash -eq $null){
            Write-Host "No User hashtable found."
        } 
        else { #Creating New AD User is hashtable is found
            Write-Host "Creating new user from hashtable."
            New-ADUser @UserHash
        }
        NewUser 
        ### Checking for Manual Parameters
        # Questions: 1) What parameters are required to successfully create a functional new AD User?
        #            2) Of these parameters, what can be adapted from other parameters?
        #               (e.g. getting jsmith from GivenName = 'John' and Surname = 'Smith')
        #            3) Which of these parameters can be hardcoded and which can be passed through the CLI?
    }
    ### Start END Block
    END {}

}

function CSV-FileCheck {
        Write-Host "Beginning user import."
        $ADUsers = Import-CSV $CSVFileName
        Write-Host "Creating new user accounts from $CSVFileName"
        foreach ($User in $ADUsers)
        {
            $Username = $User.username
            $Password = $User.password 
            $Firstname = $User.firstname
            $Lastname = $User.lastname
            $OU = $User.ou
            #$CardNumber = $User.cardnumber
            #$CardPIN = $User.cardpin
            #$PrimaryGroup = Get-ADGroup "SambaUsers"
            #$groupSid = $PrimaryGroup.sid
            #[int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)

            #Check if user account already exists in AD
            if (Get-ADUser -F {SamAccountName -eq $Username}){
                #If user doesn't exist, output a warning message
                Write-Warning "A user account $Username already has an Active Directory Account."
            }
            else {
                #User doesn't exist, create a new user account
                #Account will be created in the OU listed in the $OU variable in the CSV file; edit domain name in "-UserPrincipalName" and address in "-EmailAddress"
                Write-Verbose "Now creating new user account: '$Username'" -Verbose
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
                #$Groups = @("SambaUsers","Austin","confluence-users","Google Apps","jira-users","Nexmark" )
                #foreach ($Group in $Groups) { Add-ADPrincipalGroupMembership $Username -MemberOf $Group }
                #Assign Access Card, Access PIN to User, and "SambaUsers" as Primary Group
                #Set-ADUser -Identity $Username <#-Add @{gtecFacilityCode=105; gtecAccessCard="$CardNumber"; gtecAccessPin="$CardPIN"}#> `
                #-Replace @{primaryGroupID="$GroupID"}
                Write-Verbose "User '$Firstname $Lastname' successfully created with username '$Username'" -Verbose
            }
        }
    }

function NewUser {
#Write-Host -ForegroundColor Yellow 'Please enter new user information below'
echo "In NewUser function"

Write-Host "$Firstname is first name."
Write-Host "$Lastname is last name."
#$password = Read-Host -assecurestring "Please enter your password"
#$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
}