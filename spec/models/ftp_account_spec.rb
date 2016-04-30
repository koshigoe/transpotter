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

require 'rails_helper'

RSpec.describe FtpAccount, :type => :model do
  describe '#password=' do
    subject { FtpAccount.new(password: 'password') }

    it 'is set hashed password to password_digest' do
      expect(subject.password_digest).to match /\A\{sha256\}[a-zA-Z0-9\+\/=]+\z/
    end
  end
end
