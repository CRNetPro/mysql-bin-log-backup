
## schedule the execution of program binlog-backup.sh
```bash
$ sudo vi /etc/crontab

0 */8 * * * root /dir/binlog-backup.sh >> /var/log/backup-binlog.log 2>&1
```
