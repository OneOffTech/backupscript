#!/bin/bash

# read configuration variables
source ~/.backup.cfg

export RESTIC_PASSWORD=${BACKUP_PASSWORD}

$RESTIC --repo $URI snapshots

unset RESTIC_PASSWORD
