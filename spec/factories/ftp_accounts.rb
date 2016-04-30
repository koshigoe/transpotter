# ## Schema Information
#
# Table name: `ftp_accounts`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `integer`          | `not null, primary key`
# **`username`**         | `string`           | `not null`
# **`password_digest`**  | `string`           | `not null`
# **`uid`**              | `integer`          | `default("500"), not null`
# **`gid`**              | `integer`          | `default("500"), not null`
# **`homedir`**          | `string`           | `default("/home/vagrant"), not null`
# **`shell`**            | `string`           | `default(""), not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
#

FactoryGirl.define do
  factory :ftp_account do
    sequence(:username) { |n| "ftp-#{n}" }
    password "{sha256}#{Base64.strict_encode64 Digest::SHA256.digest('password')}"
  end
end
