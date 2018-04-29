#!/bin/bash

# read configuration variables
source ~/.backup.cfg

export RESTIC_PASSWORD=${BACKUP_PASSWORD}

# use the supplied parameters as a mountpoint
$RESTIC --repo $URI mount ${@}

unset RESTIC_PASSWORD
