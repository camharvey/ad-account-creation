$group = get-adgroup "SambaUsers"
$groupSid = $group.sid
$groupSid
[int]$GroupID = $groupSid.Value.Substring($groupSid.Value.LastIndexOf("-")+1)

Get-ADUser "jsmith" | Set-ADObject -Replace @{primaryGroupID="$GroupID"}
