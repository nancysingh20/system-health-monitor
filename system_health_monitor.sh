#!/bin/bash

set -euo pipefail

print_header() {
    echo "========================================================"
    echo "               SYSTEM HEALTH MONITOR"
    echo "========================================================"
}

system_info() {
    echo
    echo "---------------- System Information ----------------"
    echo "Hostname      : $(hostname)"
    echo "Current User  : $(whoami)"
    echo "Current Date  : $(date)"
}

cpu_info() {
    echo
    echo "---------------- CPU Statistics ----------------"
    vmstat
}

memory_info() {
    echo
    echo "---------------- Memory Usage ----------------"
    free -h

    MEMORY_USAGE=$(free | awk '/Mem:/ {
        printf "%.0f", ($3 / $2) * 100
    }')

    echo
    echo "Memory Usage: ${MEMORY_USAGE}%"

    if [ "$MEMORY_USAGE" -ge 80 ]; then
        echo "CRITICAL: Memory usage is above 80%."
        return 1
    else
        echo "HEALTHY: Memory usage is below 80%."
    fi
}

disk_info() {
    echo
    echo "---------------- Disk Usage ----------------"
    df -h

    DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

    echo
    echo "Root Disk Usage: ${DISK_USAGE}%"

    if [ "$DISK_USAGE" -ge 80 ]; then
        echo "CRITICAL: Disk usage is above 80%."
        return 1
    else
        echo "HEALTHY: Disk usage is below 80%."
    fi
}

uptime_info() {
    echo
    echo "---------------- System Uptime ----------------"
    uptime
}

generate_report() {
    print_header
    system_info
    cpu_info
    memory_info
    disk_info
    uptime_info
}

generate_report | tee health_report.txt

echo
echo "========================================================"
echo "Health report generated successfully."
echo "Report saved as: health_report.txt"
echo "========================================================"
