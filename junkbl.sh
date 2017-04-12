cat -v /tmp/extracted-JunkEmails.asc | tr , '\n' | sed 's/[{}]//g;s/^[ \t]*//;/^\s*$/d;s/\^M//g' | grep . | grep -v BlockedSendersAndDomains | sort | uniq -u | sed 's/$/\t 550/' > /etc/postfix/junkbl_access
postmap /etc/postfix/junkbl_access
