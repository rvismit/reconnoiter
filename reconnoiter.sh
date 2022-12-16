#!/bin/bash

# Author: DRUK
# Reconnoiter: https://github.com/rvismit/reconnoiter
# twitter: https://www.twitter.com/th3_druk
# Created Dec 2019 | Monastery
# Updated on Oct 2022
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
        curl  https://api.hackertarget.com/hostsearch/?q=$vardomain | cut -d',' -f1 | sort -u | grep $vardomain >> subdomains.txt
        curl  http://web.archive.org/cdx/search/cdx?url=*.$vardomain/\&output=text\&fl=original\&collapse=urlkey | grep $vardomain | sed -e 's_https*://__' -e "s/\/.*//" >> subdomains.txt        
	curl  http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$vardomain\&output=json | jq -r .url | sort -u >>  subdomains.txt
        curl  https://api.threatminer.org/v2/domain.php?q=$vardomain\&rt=5 | jq '.' | sort -u | grep $vardomain >>  subdomains.txt
        curl  https://riddler.io/search?q=pld:$vardomain | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u >>  subdomains.txt
        curl -s https://crt.sh/?q=%.$vardomain | grep -oE "[\.a-zA-Z0-9-]+\.$vardomain" | sort -u >>  subdomains.txt
        curl  https://sonar.omnisint.io/subdomains/$vardomain | jq -r ".[]" | sort -u >>  subdomains.txt
        curl https://jldc.me/anubis/subdomains/$vardomain | jq -r ".[]" | sort -u >>  subdomains.txt
        webchk -i ./subdomains.txt | grep '200' >> httpstatus.txt #Check website status
        else
                echo -e "Invalid Host"
        fi
