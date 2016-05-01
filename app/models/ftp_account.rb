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
  validates :username, presence: true, format: { with: /\Aftp-\d+\z/, allow_blank: true }
  validates :password_digest, presence: true
  validates :uid, presence: true, numericality: { allow_blank: true }
  validates :gid, presence: true, numericality: { allow_blank: true }
  validates :homedir, presence: true

  attr_readonly :username

  def password=(raw_password)
    self.password_digest = "{sha256}#{Base64.strict_encode64(Digest::SHA256.digest(raw_password))}"
  end
end
