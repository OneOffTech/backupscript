#!/bin/bash

# read configuration variables
source ~/.backup.cfg

export RESTIC_PASSWORD=${BACKUP_PASSWORD}

$RESTIC --repo $URI $QUIET prune "$@"

unset RESTIC_PASSWORD
