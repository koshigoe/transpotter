Transpotter
====

Setup
----

```
$ bundle install
$ vagrant plugin install vagrant-hostmanager
$ vagrant up
$ vagrant hostmanager
$ itamae-secrets newkey --base=./.secrets/vagrant --method=aes-rando
$ itamae-secrets set --base=./.secrets/vagrant secret_key_base $(rake secret)
$ itamae-secrets set --base=./.secrets/vagrant aws_access_key_id <AWS ACCESS KEY ID>
$ itamae-secrets set --base=./.secrets/vagrant aws_secret_access_key <AWS SECRET ACCESS KEY>
$ cap vagrant itamae:secrets:upload
$ cap vagrant itamae
$ cap vagrant serverspec
$ cap vagrant deploy
```
