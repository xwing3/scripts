# Magento liveness probe shell script for Kubernetes. Can be used when nginx and magento are in the same container.

#!/bin/bash
response=$(curl -sL -w "%{http_code}\\n" --header "Host: "$HOST_MAGENTO"" $HOSTNAME:8080/index.php -o /dev/null);
if [[ "$response" -gt 199 && "$response" -lt 400 ]] ; then echo HTTP Code: $response; unset response; exit 0; else echo HTTP Code: $response; exit 127; fi
