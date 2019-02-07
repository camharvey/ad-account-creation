$group = get-adgroup "UserGroup" #Enter your Group name here
$groupSid = $group.sid
$groupSid
[int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)

Get-ADUser "jsmith" | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
