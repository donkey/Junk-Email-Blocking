cat -v /tmp/extracted-JunkEmails.asc | tr , '\n' | sed 's/[{}]//g;s/[\t ]//g;/^$/d;s/\^M$//g;s/BlockedSendersAndDomains://g' | grep . | sort | uniq -u | sed 's/$/\t 550/'  > /etc/postfix/junkbl_access
postmap /etc/postfix/junkbl_access
