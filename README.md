Transpotter
====

Setup
----

```
$ export AWS_REGION=ap-northeast-1
$ export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
$ export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
$ bundle install
$ vagrant plugin install vagrant-hostmanager
$ vagrant up
$ vagrant hostmanager
$ itamae-secrets newkey --base=./.secrets/vagrant --method=aes-rando
$ itamae-secrets set --base=./.secrets/vagrant secret_key_base $(rake secret)
$ itamae-secrets set --base=./.secrets/vagrant aws_access_key_id $AWS_ACCESS_KEY
$ itamae-secrets set --base=./.secrets/vagrant aws_secret_access_key $AWS_SECRET_ACCESS_KEY
$ cap vagrant itamae:secrets:upload
$ cap vagrant itamae
$ cap vagrant serverspec
$ cap vagrant deploy
$ rake db:create db:migrate db:seed
```

FTP/SFTP Account
----

```
$ bin/transpotter auth token <API USER NAME>
API password:
Authentication success!!
$ bin/transpotter account create --type ftp
Enter new account password:
New account created!!
+----------+---------------+
| Key      | Value         |
+----------+---------------+
| username | ftp-12        |
| uid      | 1000          |
| gid      | 1000          |
| homedir  | /home/vagrant |
| shell    |               |
+----------+---------------+
$ ftp ftp-12@ftp.transpotter.vm
Connected to ftp.transpotter.vm.
220 FTP Server ready.
331 Password required for ftp-12
Password:
230 User ftp-12 logged in
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>
$ bin/transpotter account create --type sftp
Enter new account password:
New account created!!
+----------+---------------+
| Key      | Value         |
+----------+---------------+
| username | sftp-3        |
| uid      | 1000          |
| gid      | 1000          |
| homedir  | /home/vagrant |
| shell    |               |
+----------+---------------+
$ sftp -P 2222 sftp-3@sftp.transpotter.vm
sftp-3@sftp.transpotter.vm's password:
Connected to sftp.transpotter.vm.
sftp>
```
