Transpotter
====

Setup
----

### AWS

Transpotter require AWS credentials to use S3.

```
$ export AWS_REGION=ap-northeast-1
$ export AWS_ACCESS_KEY_ID=<AWS_ACCESS_KEY_ID>
$ export AWS_SECRET_ACCESS_KEY=<AWS_SECRET_ACCESS_KEY>
```

#### S3

Transpotter use some S3 bucket. Transpotter gets bucket names from environment variables.

- `TRANSPOTTER_S3_BUCKET`
    - This bucket is used to upload file from (S)FTP server.
- `SECRETS_BUCKET`
    - This bucket is used to manage secrets files.

### Create VM & deploy

```
$ bundle install
$ vagrant up
$ itamae-secrets newkey --base=./.secrets/vagrant --method=aes-rando
$ itamae-secrets set --base=./.secrets/vagrant secret_key_base $(rake secret)
$ itamae-secrets set --base=./.secrets/vagrant aws_access_key_id $AWS_ACCESS_KEY
$ itamae-secrets set --base=./.secrets/vagrant aws_secret_access_key $AWS_SECRET_ACCESS_KEY
$ cap vagrant itamae:secrets:upload
$ cap vagrant itamae
$ cap vagrant serverspec
$ rake db:create
$ cap vagrant deploy
$ rake db:seed
$ sudo mkdir /etc/resolver
$ echo 'nameserver 192.168.33.53' | sudo tee /etc/resolver/vm
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
+----------+---------------------+
| Key      | Value               |
+----------+---------------------+
| username | ftp-3               |
| uid      | 1000                |
| gid      | 1000                |
| homedir  | /home/vagrant/ftp-3 |
| shell    |                     |
+----------+---------------------+
$ ftp ftp-3@ftp.transpotter.vm
Connected to ftp.transpotter.vm.
220 FTP Server ready.
331 Password required for ftp-3
Password:
230 User ftp-3 logged in
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>
$ bin/transpotter account create --type sftp
Enter new account password:
New account created!!
+----------+----------------------+
| Key      | Value                |
+----------+----------------------+
| username | sftp-3               |
| uid      | 1000                 |
| gid      | 1000                 |
| homedir  | /home/vagrant/sftp-3 |
| shell    |                      |
+----------+----------------------+
$ sftp -P 2222 sftp-3@sftp.transpotter.vm
sftp-3@sftp.transpotter.vm's password:
Connected to sftp.transpotter.vm.
sftp>
```

Call Web API directly:

```
$ jq . -c <<JSON | curl -s -X POST \
  -H "Authorization: Token $(cat .transpotter-token)" \
  -H 'Content-Type: application/json' \
  -d @- http://api.transpotter.vm/v1.0/ftp-accounts | jq .
{
  "data": {
    "type": "ftpAccount",
    "attributes": {
      "password": "password"
    }
  }
}
JSON
```
