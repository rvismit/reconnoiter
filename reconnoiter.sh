#!/bin/bash

# Author: DRUK
# Reconnoiter: https://github.com/rvismit/reconnoiter
# twitter: https://www.twitter.com/th3_druk
# Created Dec 2019 | Monastery
# Updated on May 2025
# New updates coming soon.

echo            "  ____                                  _ _"
echo            " |  _ \ ___  ___ ___  _ __  _ __   ___ (_) |_ ___ _ __"
echo            " | |_) / _ \/ __/ _ \| '_ \| '_ \ / _ \| | __/ _ \ '__|"
echo            " |  _ <  __/ (_| (_) | | | | | | | (_) | | ||  __/ |"
echo            " |_| \_\___|\___\___/|_| |_|_| |_|\___/|_|\__\___|_|"
echo '\n'
#Install Webcheck : pip install webchk
echo  "Enter Your Domain Name:"  "E.g exapmle.com"
read vardomain

        if
                host $vardomain
                then
                echo "Resolved"
        curl -s https://api.hackertarget.com/hostsearch/?q=$vardomain | cut -d',' -f1 | sort -u | grep $vardomain >> subdomains.txt
        curl -s http://web.archive.org/cdx/search/cdx?url=*.$vardomain/\&output=text\&fl=original\&collapse=urlkey | grep $vardomain | sed -e 's_https*://__' -e "s/\/.*//" >> subdomains.txt        
	curl -s http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$vardomain\&output=json | jq -r .url | sort -u >>  subdomains.txt
        curl -s https://otx.alienvault.com/api/v1/indicators/domain/$vardomain/passive_dns | jq -r '.passive_dns[].hostname' | grep -w "$vardomain$" | sort -u >> subdomains.txt
        curl -s https://riddler.io/search?q=pld:$vardomain | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >>  subdomains.txt
        curl -s https://crt.sh/?q=%.$vardomain | grep -oE "[\.a-zA-Z0-9-]+\.$vardomain" | sort -u >>  subdomains.txt
        curl -s https://rapiddns.io/subdomain/$vardomain?full=1 | grep -oP "([a-zA-Z0-9_-]+\.)+$vardomain" | sort -u >> subdomains.txt
        webchk -i ./subdomains.txt | grep '200' >> httpstatus.txt #Check website status
        else
                echo -e "Invalid Host"
        fi
