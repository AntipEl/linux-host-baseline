#!/bin/bash

domain="google.com"
port="443"
url="https://${domain}/"

echo "===================================="
echo "========= Network Healthcheck ======"
echo "===================================="

# 1. DNS check
ip_address=$(getent ahostsv4 "$domain" | awk 'NR==1 {print $1}')

if [[ -z "$ip_address" ]]; then
    echo "ERROR: DNS resolution failed for $domain"
    exit 1
fi

echo "DNS: OK ($domain -> $ip_address)"

# 2. Route check
if ! ip route get "$ip_address" >/dev/null 2>&1; then
    echo "ERROR: No route to $ip_address"
    exit 2
fi

echo "Route: OK"

# 3. TCP check
if ! nc -z -w 5 "$domain" "$port" 2>/dev/null; then
    echo "ERROR: TCP connection failed ($domain:$port)"
    exit 3
fi

echo "TCP: OK ($port)"

# 4. TLS check
if ! timeout 10 openssl s_client \
    -connect "${domain}:${port}" \
    -servername "$domain" \
    -verify_return_error \
    -brief </dev/null >/dev/null 2>&1; then
    echo "ERROR: TLS connection failed"
    exit 4
fi

echo "TLS: OK"

# 5. HTTP check
http_status=$(curl -sS -o /dev/null -w "%{http_code}" \
    --connect-timeout 5 --max-time 10 "$url")

if [[ "$http_status" -lt 200 || "$http_status" -ge 400 ]]; then
    echo "ERROR: HTTP request failed. Status: $http_status"
    exit 5
fi

echo "HTTP: OK (status $http_status)"

echo
echo "Network healthcheck: OK"

exit 0