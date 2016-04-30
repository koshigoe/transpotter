# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `integer`          | `not null, primary key`
# **`username`**         | `string`           | `not null`
# **`password_digest`**  | `string`           | `not null`
#
# ### Indexes
#
# * `idx_users_name` (_unique_):
#     * **`username`**
#

class User < ApplicationRecord
  has_secure_password

  def token
    payload = {
      sub: id.to_s,
      aud: id.to_s,
      iat: Time.current.to_i,
      exp: 1.day.from_now.to_i,
    }
    JWT.encode payload, Rails.application.secrets[:secret_key_base], 'HS256'
  end

  def verify_token(token)
    verify_options = {
      algorithm: 'HS256',
      verify_expiration: true,
      verify_iat: true,
      verify_sub: true,
      sub: id.to_s,
    }
    JWT.decode(token, Rails.application.secrets[:secret_key_base], true, verify_options)
    true
  rescue
    false
  end
end
