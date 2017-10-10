#!/bin/bash

# read configuration variables
source config.sh

export RESTIC_PASSWORD=${BACKUP_PASSWORD}
$RESTIC --repo $URI snapshots
unset RESTIC_PASSWORD

exit 0

