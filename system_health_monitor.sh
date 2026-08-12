#!/bin/bash

set -euo pipefail

# ==================================================
# System Health Monitor
# Author : Nancy Singh
#
# Description:
# Displays important system information including
# hostname, current user, memory usage, disk usage,
# CPU statistics, and uptime.
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
}

memory_info() {
    echo
    echo "---------------- Memory Usage ----------------"
    free -h
}

disk_info() {
    echo
    echo "---------------- Disk Usage ----------------"
    df -h
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
