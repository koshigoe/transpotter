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
  def password=(raw_password)
    self.password_digest = "{sha256}#{Base64.strict_encode64(Digest::SHA256.digest(raw_password))}"
  end
end
