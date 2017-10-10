#!/bin/bash

# read configuration variables
source config.sh

export RESTIC_PASSWORD=${BACKUP_PASSWORD}

$RESTIC --repo $URI $QUIET prune "$@"

unset RESTIC_PASSWORD
