# ## Schema Information
#
# Table name: `ftp_accounts`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `integer`          | `not null, primary key`
# **`username`**         | `string`           |
# **`password_digest`**  | `string`           | `not null`
# **`uid`**              | `integer`          | `not null`
# **`gid`**              | `integer`          | `not null`
# **`homedir`**          | `string`           | `not null`
# **`shell`**            | `string`           | `default(""), not null`
# **`created_at`**       | `datetime`         | `not null`
# **`updated_at`**       | `datetime`         | `not null`
#

require 'digest/sha2'
require 'base64'

class FtpAccount < ApplicationRecord
  validates :password, presence: true, on: :create
  validates :uid, presence: true, numericality: { allow_blank: true }
  validates :gid, presence: true, numericality: { allow_blank: true }
  validates :homedir, presence: true

  attr_readonly :username
  attr_accessor :password

  before_save do
    self.password_digest = "{sha256}#{Base64.strict_encode64(Digest::SHA256.digest(password))}" if password.present?
  end
end
