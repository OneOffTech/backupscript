#!/bin/bash

# dir to backup

cd $(dirname $0)

usage() {
    echo "backup script with snapshots"
    echo "$0 [-x exclude dir] [-k N] <backup dir>"
    echo
    echo "  -x excludes sub directory"
    echo "  -k defines how many snapshots to keep (default 7)"
    echo "  -q supress verbose output"
    echo
}

# read configuration variables
source ~/.backup.cfg

BDIR=""
EXCLUDE=""

#### READ PARAMETERS

while getopts ":x:hqk:" opt; do
    case $opt in
        x)
            EXCLUDE="${EXCLUDE} --exclude ${OPTARG}"
            ;;
        h)
            usage
            exit 0
            ;;
        q)
            QUIET="--quiet"
            ;;
        k)
            KEEPLAST="${OPTARG}"
            ;;
        \?)
            echo "ERROR: Invalid option: -$OPTARG" >&2
            usage
            exit 1
            ;;
        :)
            echo "ERROR: Option -$OPTARG requires an argument." >&2
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

BDIR=${1}

if [ -z "$BDIR" ]; then
    echo "ERROR: Missing backup directory!" >&2
    usage
    exit 2
fi

#### END READ PARAMETERS

export RESTIC_PASSWORD=${BACKUP_PASSWORD}

echo "Backup path: $BDIR"
sync
# backup the snapshot (without freezing the filesystem)
# use -q for quiet mode (when run as a cron job)
ionice -c 3 $RESTIC --repo $URI $EXCLUDE $QUIET backup $BDIR

# delete everything older than the last X snapshots
$RESTIC --repo $URI $QUIET forget --keep-last $KEEPLAST --path "$BDIR"

unset RESTIC_PASSWORD

exit 0
