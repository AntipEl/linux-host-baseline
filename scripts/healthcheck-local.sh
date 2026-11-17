#!/bin/bash

endpoint="http://127.0.0.1:8080/health"

echo "===================================="
echo "============ Healthcheck ==========="
echo "===================================="

# Check application endpoint and HTTP status
http_status=$(curl -sS -o /dev/null -w "%{http_code}" "$endpoint")

if [[ "$http_status" != "200" ]]; then
    echo "ERROR: Healthcheck failed. HTTP status: $http_status"
    exit 1
fi

# Display application information
echo
echo "Application listener:"
ss -ltnp 'sport = :8080'

echo
echo "HTTP status: $http_status"
echo "Endpoint: $endpoint"

echo
echo "Healthcheck: OK"
