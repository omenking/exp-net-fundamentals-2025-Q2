#!/bin/bash
# haproxy-startup.sh - Script to start HAProxy with custom configuration

# Set variables
CONFIG_FILE="/usr/local/etc/haproxy/haproxy-new.cfg"
PID_FILE="/var/run/haproxy.pid"

# Check if config file exists
if [ ! -f "${CONFIG_FILE}" ]; then
    echo "Error: Configuration file ${CONFIG_FILE} not found!"
    exit 1
fi

# Validate the configuration
echo "Validating HAProxy configuration..."
haproxy -c -f ${CONFIG_FILE}
if [ $? -ne 0 ]; then
    echo "Error: Invalid configuration in ${CONFIG_FILE}"
    exit 1
fi

# Check if port 80 is already in use by another process
if netstat -tuln | grep -q ":80 "; then
    echo "Warning: Port 80 is already in use. Finding the process..."

    # Find and kill process using port 80
    PID=$(netstat -tulnp | grep ":80 " | awk '{print $7}' | cut -d'/' -f1)
    if [ ! -z "$PID" ]; then
        echo "Stopping process with PID $PID that is using port 80..."
        kill -15 $PID
        sleep 2
    fi
fi

# Check if HAProxy is already running
if [ -f "${PID_FILE}" ] && kill -0 $(cat ${PID_FILE}) 2>/dev/null; then
    echo "HAProxy is already running. Performing graceful restart..."
    haproxy -f ${CONFIG_FILE} -p ${PID_FILE} -sf $(cat ${PID_FILE})
else
    echo "Starting HAProxy with ${CONFIG_FILE}..."
    haproxy -W -db -f ${CONFIG_FILE} -p ${PID_FILE}
fi

# If running in container, keep the script running
if [ "$1" = "keep-alive" ]; then
    echo "Container started. HAProxy running with PID: $(cat ${PID_FILE})"
    # Keep the script running to prevent container exit
    trap 'kill -TERM $(cat ${PID_FILE})' TERM INT
    wait
fi

exit 0
