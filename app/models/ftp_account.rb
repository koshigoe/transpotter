# ## Schema Information
#
# Table name: `ftp_accounts`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`id`**          | `integer`          | `not null, primary key`
# **`username`**    | `string`           | `not null`
# **`password`**    | `string`           | `not null`
# **`uid`**         | `integer`          | `default("500"), not null`
# **`gid`**         | `integer`          | `default("500"), not null`
# **`homedir`**     | `string`           | `default("/home/vagrant"), not null`
# **`shell`**       | `string`           | `default(""), not null`
# **`created_at`**  | `datetime`         | `not null`
# **`updated_at`**  | `datetime`         | `not null`
#

class FtpAccount < ApplicationRecord
end
