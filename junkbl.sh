# build postfix junk emails
cat -v /tmp/extracted-JunkEmails.asc | tr , '\n' | sed 's/[{}]//g;s/[\t ]//g;/^$/d;s/\.\.\.//g;s/\^M$//g;s/BlockedSendersAndDomains://g' | grep . | sort | uniq -u | sed 's/$/\t 550 message was classified as spam/'  > /etc/postfix/junkbl_access
postmap /etc/postfix/junkbl_access
# build postfix trusted emails
cat -v /tmp/extracted-TrustedEmails.asc | tr , '\n' | sed 's/[{}]//g;s/[\t ]//g;/^$/d;s/\^M$//g;s/TrustedSendersAndDomains://g' | grep . | sort | uniq -u | sed 's/$/\t ok/' > /etc/postfix/trusted_access
postmap /etc/postfix/trusted_access
