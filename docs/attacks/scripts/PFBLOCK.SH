#!/bin/sh

ACTION="$1"
USER="$2"
IP="$3"

PFSENSE="10.0.10.1"
SSH_USER="admin"
LOG_FILE="/var/ossec/logs/active-responses.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $0: $1" >> "$LOG_FILE"
}

# Check input
if [ -z "$ACTION" ] || [ -z "$IP" ]; then
    log "Missing parameters: ACTION=$ACTION IP=$IP"
    exit 1
fi

# IPv4 strict validation 0-255
echo "$IP" | awk -F'.' '{
    if (NF != 4) exit 1;
    for (i=1;i<=4;i++)
        if ($i !~ /^[0-9]+$/ || $i < 0 || $i > 255) exit 1;
    exit 0
}' || {
    log "Invalid IP format: $IP"
    exit 1
}

case "$ACTION" in
    add)
        log "Blocking IP $IP targeting user $USER via pfSense"
        ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
            "${SSH_USER}@${PFSENSE}" "easyrule block wan $IP"
        [ $? -eq 0 ] && log "Successfully blocked $IP" || log "Failed to block $IP"
        ;;
    delete)
        log "Unblocking IP $IP via pfSense"
        ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 \
            "${SSH_USER}@${PFSENSE}" "easyrule unblock wan $IP"
        [ $? -eq 0 ] && log "Successfully unblocked $IP" || log "Failed to unblock $IP"
        ;;
    *)
        log "Unknown action: $ACTION"
        exit 1
        ;;
esac

exit 0
