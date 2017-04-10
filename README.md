## Junk-Email-Blocking

![Junk Email Blocking](https://github.com/donkey/Junk-Email-Blocking/blob/master/junkemails.png)

_Extract Outlook junk email addresses from mailboxes write to file being distribute them to Postfix Smarthost_

### Preface
No one likes spam emails, to curb the flood of unsolicited emails, incoming emails have to go through several filters and so-called Milters. An efficient filter solution is provided by Postfix's Mail Transfer Agent, the Open Source program was developed by Wietse Zweitze Venema in 1998. Postfix is a powerful mail transfer agent - MTA for Unix and Unix derivatives. The software should be a compatible alternative to Sendmail at the time of development. During programming, special attention was paid to safety aspects. The source code of Postfix is available under the IBM Public License and is thus free software. Postfix MTA's are increasingly used by many internet providers and large companies.

The Software architecture of Postfix allows to implement a variety of filters, such as SpamAssassin this under the Apache license, to filter out and block unwanted emails, or to check the behavior of a sender with greylisting routines. Protection against viruses and malicious code provides Clam AntiVirus - ClamAV is under the GNU General Public License.

As an e-mail client software often using in companies is MS Outlook they are widely used in conjuction with MS Exchange. Outlook offers the possibility to block unwanted sender, the name is not exactly correct, the so-called junk e-mails are not blocked on the server, but are moved into the Outlook folder Junk E-Mail. It would be better if the alleged sender is not able to deliver it, so it will rejected, the sending server (MTA) is now to see what he should doing with.

There is a possibility to intervene when the Exchange Server does not receive e-mails directly from the Internet, but rather oprate via a Smarthost. Smarthosts are mostly Linux-based servers that work with the Postfix MTA.

### Installation
The PowerShell script _JunkEmails.ps1_ retrieves the junk e-mail entries from the Outlook junk e-mail list of blocked senders of any users mailbox, and extracts formatted output as Windows ANSI text and into an ACSII text file.

The script is run as an administrator on the Exchange Server in the Exchange Management Shell, suitably as a job in task scheduling, e.g. at any hour.

PuTTY is required on the exchange server, after the installation of PuTTY 64bit done, _pscp.exe_ (PuTTY Secure Copy) is used to transfer the block list blocked senders to the Smarthost. In order to avoid a password prompt, a keyparent must be created with PuTTY Key Generator (_puttygen.exe_). The generated public key is copied into the file _authorized_keys_ under the home directory of the user in the directory .ssh. So the script with _pscp_ is able to authenticate at the Smarthost.

On the Linux Smarthost is a shell script to convert the lines to the Unix (LF) format. This one-line creates the appropriate output to the postfix directory via pipe to the _junkbl_access_ file. Save the `code` to a scrip file like _junkbl.sh_.

`cat /tmp/extracted-JunkEmails.asc | tr , '\n' | sed 's/[{}]//g;s/^[ \t]*//;/^\s*$/d;s/\r$//g;s/$/\t 550/' | tail -n+3 > /etc/postfix/junkbl_access`

The stream-editor - sed converts the line breaks, removes empty characters and inserts the error code 550 at the end of each line, so that the unsolicited e-mails of the blocked senders list are rejected during the attempt to deliver.

To create Postfix DB _junkbl_access.db_ and update them on the Linux console of the Postfix MTA.<br>
`postmap /etc/postfix/junkbl_access`

Add junkbl to the Postfix main configuration `/etc/postfix/main.cf`<br>
`smtpd_sender_restrictions =
   check_sender_access hash:/etc/postfix/junkbl_access,
`

After a `postfix reload` the Outlook Blocklist are applied.

A cronjob will update the junk-email blacklist continuously.
`5 * * * * /usr/bin/junkbl.sh >/dev/null 2>&1`

### Note
How to run Exchange Management Shell scripts are out from task scheduler, you can consulate [Exchange MailboxStatistics Mail Report](http://think.unblog.ch/exchange-mailboxstatistics-mail-report/).
