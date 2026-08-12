#!/bin/bash

set -euo pipefail

OVERALL_STATUS="HEALTHY"

# ==================================================
# System Health Monitor
# Author : Nancy Singh
# ==================================================

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

    CPU_USAGE=$(vmstat 1 2 | tail -1 | awk '{print 100 - $15}')

    echo
    echo "CPU Usage: ${CPU_USAGE}%"

    if [ "$CPU_USAGE" -ge 80 ]; then
        echo "CRITICAL: CPU usage is above 80%."
        OVERALL_STATUS="CRITICAL"
    else
        echo "HEALTHY: CPU usage is below 80%."
    fi
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
        OVERALL_STATUS="CRITICAL"
    else
        echo "HEALTHY: Memory usage is below 80%."
    fi
}

disk_info() {
    echo
    echo "---------------- Disk Usage ----------------"

    df -h

    DISK_USAGE=$(df / | awk 'NR==2 {
        gsub("%","")
        print $5
    }')

    echo
    echo "Root Disk Usage: ${DISK_USAGE}%"

    if [ "$DISK_USAGE" -ge 80 ]; then
        echo "CRITICAL: Disk usage is above 80%."
        OVERALL_STATUS="CRITICAL"
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

    echo
    echo "========================================================"
    echo "OVERALL SYSTEM HEALTH: $OVERALL_STATUS"
    echo "========================================================"
}

# ==================================================
# Generate Report
# ==================================================

generate_report > health_report.txt

# Display report in Jenkins console
cat health_report.txt

# ==================================================
# Determine Pipeline Result
# ==================================================

if [ "$OVERALL_STATUS" = "CRITICAL" ]; then
    echo
    echo "System health check failed."
    echo "One or more system resources exceeded the threshold."
    exit 1
fi

echo
echo "Health report generated successfully."
echo "Report saved as: health_report.txt"

exit 0
