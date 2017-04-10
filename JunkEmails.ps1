<#
  JunkEmails.ps1 extract junk email addresses from mailboxes and write to file being distribute to smarthost
  Version 1.0.1 (07.04.2017) by DonMatteo
  Mail: think@unblog.ch
  Blog: think.unblog.ch
#>
 
$Smarthost = "user@smarthost.mydomain.com:/tmp"
$User_Path = (Get-Item env:\localappdata).Value
$Junk_Path = "$User_Path\Junk"
if(!(Test-Path -Path $Junk_Path )){
    New-Item -ItemType directory -Path $Junk_Path
}
$input_file = "$Junk_Path\JunkEmails.txt"
$output_asc = "$Junk_Path\extracted-JunkEmails.asc"
$output_txt = "$Junk_Path\extracted-JunkEmails.txt"
 
$junkemails = (Get-MailboxJunkEmailConfiguration -Identity * | Select BlockedSendersAndDomains)
$junkemails | Out-File -FilePath $output_asc -Encoding ASCII
$junkemails | Out-File -FilePath $input_file
 
$regex = "\b[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\b"
Select-String -Path $input_file -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $output_txt
 
& "C:\Program Files\PuTTY\pscp.exe" "$output_asc" "$Smarthost"
