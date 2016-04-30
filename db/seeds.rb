# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'digest/sha2'

FtpAccount.create_with(password: "{sha256}#{Base64.strict_encode64 Digest::SHA256.digest('password')}").find_or_create_by!(username: 'ftp-1')
