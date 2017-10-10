## Backup scripts

These are the scripts that are used for automatic backups and management of
the available backups.

### Installation
 * Copy the backup scripts into a secluded location, for example
   `/opt/backups`
 * Download the restic backend binary. This version of the scripts was
   tested with release 0.7.3, but should also be compatible with later
   releases. you can do this quickly by running
   `curl https://github.com/restic/restic/releases/download/v0.7.3/restic_0.7.3_linux_amd64.bz2 | bunzip2 > /usr/local/bin/restic`
   and make it executable with
   `chmod 755 /usr/local/bin/restic && chown root: /usr/local/bin/restic`.
 * set up the crontab, in order for the backup to run in regular intervals:
   `crontab -e` (refer to the contab.example file in this folder.)

### Configuration
 First Make sure your backup backend is connectable and has enough free
 storage space. Remote backends are preferable since they are usually
 operating independent from the rest of your infrastructure. Any of the
 following backends are supported:

  * Local directory (without prefix)
  * SFTP (prefix with `sftp:`)
  * REST compatible backend (prefix URL with `rest:`)

The following backends should work, but require additional configuration

  * Amazon S3 (prefix with `s3:`)
  * Backblaze (with prefix `b2:`)
  * Openstack Swift (prefix container name with `swift:`)

Now alter the content of the `config.sh` file to suit your needs.

Create a backup repository by running `source config.sh && restic init -r`.
This is only required once. If a repository already exists at the
destination, it will not be overwritten. You need to delete it manually
first.

You are ready to use the backup at this point, but running it manually is
not the best idea. You can create a crontab with `crontab -e` for running it
automatically.  Keep in mind that the `PATH` variable might be set different
inside the crontab. You will find a working example in the file
`crontab.example`.

You can verify what snapshots are available to restore by running the
`./list.sh` helper script.

### Maintenance
The backupscript automatically marks old backups to be deleted. Please keep
in mind that this does not delete the backups, but rather marks them as
deleted. They can even be restored after being marked as deleted, and
therefore still take up space.

To remove deleted backups, you need to run a `prune` command. this can be
done by running the `./prune.sh` helper script.

Please keep in mind that rebuilding the index and recalculating the
checksums can take up multiple hours of work, so preferably do this at
night.

## Restoration
There are two different restoration modes available for files inside a
snapshot: You can either restore the files by referencing the paths, or you
can mount the entire backup with FUSE to search and restore the files by
hand.

### FUSE
The easiest way of restoring files from a snapshot is by mounting the backup
with fuse. Simply create a mountpoint with for example `mkdir /tmp/backup`
and run the `./mount.sh /tmp/backup` helper script. Remember to unmount the
backup with `umount /tmp/backup` once you no longer need it.

You can now navigate the snapshots with normal file system utilities. A
typical backup path looks like this:
`/tmp/backup/snapshots/2017-10-04T03:00:41+02:00/gitlab/`.