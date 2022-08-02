# Replace the two X's below with your student number
host=192.168.X.31
creds=admin:f5trn0XX

get() { [ "${1:0:1}" != "/" ] && path=/mgmt/tm/ || path=; curl --silent --insecure --user $creds --request GET https://$host$path$1; }

post() { [ "${1:0:1}" != "/" ] && path=/mgmt/tm/ || path=; curl --silent --insecure --user $creds --request POST --header 'Content-Type: application/json' --data "$2" https://$host$path$1; }

put() { [ "${1:0:1}" != "/" ] && path=/mgmt/tm/ || path=; curl --silent --insecure --user $creds --request PUT --header 'Content-Type: application/json' --data "$2" https://$host$path$1; }

patch() { [ "${1:0:1}" != "/" ] && path=/mgmt/tm/ || path=; curl --silent --insecure --user $creds --request PATCH --header 'Content-Type: application/json' --data "$2" https://$host$path$1; }

delete() { [ "${1:0:1}" != "/" ] && path=/mgmt/tm/ || path=; curl --silent --insecure --user $creds --request DELETE https://$host$path$1; }
