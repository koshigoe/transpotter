# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

FTPAccount.create_with(password: 'password', uid: 1000, gid: 1000, homedir: '/home/vagrant', shell: '').find_or_create_by!(username: 'ftp-1')
SFTPAccount.create_with(password: 'password', uid: 1000, gid: 1000, homedir: '/home/vagrant', shell: '').find_or_create_by!(username: 'sftp-1')

User.create_with(password: 'password', password_confirmation: 'password').find_or_create_by!(username: 'user1')
