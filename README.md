## Check which bin log in use
``` sql
show master status;

+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 | 69006621 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
```
or check with the index file

## Schedule the execution of program binlog-backup.sh
```bash
$ sudo vi /etc/crontab

0 */8 * * * root /dir/binlog-backup.sh >> /var/log/backup-binlog.log 2>&1
```
