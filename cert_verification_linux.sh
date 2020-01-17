#!/bin/bash
set -e
LOG_FILE=/var/log/ExpiringCertificates-Monitoring.log
TMP_FILE=/tmp/tmpcert.txt
sudo touch $LOG_FILE
sudo truncate -s 0 $LOG_FILE

 for i in $(sudo find /etc/pki/tls/private -type f -name "*.pem"); do
    if [[ $i == *.pem ]]
    then
    echo "Processing $i"
    sudo openssl x509 -enddate -startdate -issuer -subject -noout -in $i > $TMP_FILE
    notAfter=$(grep notAfter $TMP_FILE  | cut -d '=' -f2-)
    validTo=$(date -d "$notAfter" +%d/%m/%Y)
    notBefore=$(grep notBefore $TMP_FILE  | cut -d '=' -f2-)
    validFrom=$(date -d "$notBefore" +%d/%m/%Y)
    issuer=$(grep issuer $TMP_FILE  | sed -e s/.*CN=//)
    subject=$(grep subject $TMP_FILE  | sed -e s/.*CN=//)
    hostname=$(hostname)
    echo "$hostname|$i|$validTo|$validFrom|$issuer|$subject" | sudo tee --append $LOG_FILE
    fi
 done; 

