#!/bin/bash

# ==================================================
# System Health Monitor
# Author : Nancy Singh
# Description:
# Displays important system information including
# hostname, current user, memory usage, disk usage,
# CPU statistics, and uptime.
# ==================================================

# Display Header
print_header() {
    echo "========================================================"
    echo "               SYSTEM HEALTH MONITOR"
    echo "========================================================"
}

# Display Basic System Information
system_info() {
    echo
    echo "Hostname      : $(hostname)"
    echo "Current User  : $(whoami)"
    echo "Current Date  : $(date)"
}

# Display CPU Information
cpu_info() {
    echo
    echo "---------------- CPU Statistics ----------------"
    vmstat
}

# Display Memory Information
memory_info() {
    echo
    echo "---------------- Memory Usage ----------------"
    free -h
}

# Display Disk Information
disk_info() {
    echo
    echo "---------------- Disk Usage ----------------"
    df -h
}

# Display System Uptime
uptime_info() {
    echo
    echo "---------------- System Uptime ----------------"
    uptime
}

# Generate Report
generate_report() {

    print_header
    system_info
    cpu_info
    memory_info
    disk_info
    uptime_info

} | tee health_report.txt

# Execute Script
generate_report

echo
echo "Health report generated successfully."
echo "Report saved as: health_report.txt"
