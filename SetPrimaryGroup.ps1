$group = get-adgroup "SambaUsers"
$groupSid = $group.sid
$groupSid
[int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)

$Users = @("bjohnson", "jsmith") #Try to determine a way to get newly created users put into an array like this
foreach ($User in $Users) { Set-ADUser $User -Replace @{primaryGroupID="$GroupID"} }

# Get-ADUser "jsmith" | Set-ADObject -Replace @{primaryGroupID="$GroupID"}