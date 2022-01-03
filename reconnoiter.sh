#!/bin/bash

# Author: DRUK
# Reconnoiter: https://github.com/rvismit/reconnoiter
# twitter: https://www.twitter.com/th3_druk
# Created Dec 2019 | Monastery
# New updates coming soon.

echo            "  ____                                  _ _"
echo            " |  _ \ ___  ___ ___  _ __  _ __   ___ (_) |_ ___ _ __"
echo            " | |_) / _ \/ __/ _ \| '_ \| '_ \ / _ \| | __/ _ \ '__|"
echo            " |  _ <  __/ (_| (_) | | | | | | | (_) | | ||  __/ |"
echo            " |_| \_\___|\___\___/|_| |_|_| |_|\___/|_|\__\___|_|"
echo -en '\n'
echo  "Enter Your Domain Name:"  "E.g exapmle.com"

read vardomain

        if
                host $vardomain
		then
		echo "Resolved"
        curl  https://www.threatcrowd.org/searchApi/v2/domain/report/?domain=$vardomain | jq '.' | sort -u | grep $vardomain >> output.txt
        curl  https://api.hackertarget.com/hostsearch/?q=$vardomain | cut -d',' -f1 | sort -u | grep $vardomain >> output.txt
        curl  https://certspotter.com/api/v0/certs?domain=$vardomain | sort -u >> output.txt
        curl  http://web.archive.org/cdx/search/cdx?url=*.$vardomain/\&output=text\&fl=original\&collapse=urlkey | grep $vardomain |sed -e 's_https*://__' -e "s/\/.*//" -e 's/:.*//' -e 's/^www\.//' | sort -u >> output.txt 
	curl  http://index.commoncrawl.org/CC-MAIN-2018-22-index?url=*.$vardomain\&output=json | jq -r .url | sort -u >> output.txt
        curl  https://api.threatminer.org/v2/domain.php?q=$vardomain\&rt=5 | jq '.' | sort -u | grep $vardomain >> output.txt
        curl  https://dns.bufferover.run/dns?q=.$vardomain |jq -r .FDNS_A[]| cut -d',' -f2| sort -u >> output.txt
        curl  https://crt.sh/?q=%.$vardomain\&output=json | jq '.' | grep $vardomain | sed 's/\"//g' | sed 's/\*\.//g' | sort -u >> output.txt
        else
		echo -e "Invalid Host"
	fi
