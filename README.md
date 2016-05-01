Transpotte
====

Setup
----

```
$ bundle install
$ vagrant up
$ itamae-secrets newkey --base=./secret --method=aes-rando
$ itamae-secrets set --base=./secret secret_key_base $(rake secret)
$ itamae-secrets set --base=./secret aws_access_key_id <AWS ACCESS KEY ID>
$ itamae-secrets set --base=./secret aws_secret_access_key <AWS SECRET ACCESS KEY>
$ cap vagrant itamae
$ cap vagrant serverspec
$ cap vagrant deploy
```
