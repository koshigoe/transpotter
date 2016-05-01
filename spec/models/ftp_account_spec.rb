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

require 'rails_helper'

RSpec.describe FtpAccount, :type => :model do
  describe 'validation' do
    subject { build(:ftp_account) }

    describe 'password_digest' do
      it { is_expected.to validate_presence_of(:password_digest) }
    end

    describe 'uid' do
      it { is_expected.to validate_presence_of(:uid) }
      it { is_expected.to validate_numericality_of(:uid) }
    end

    describe 'gid' do
      it { is_expected.to validate_presence_of(:gid) }
      it { is_expected.to validate_numericality_of(:gid) }
    end

    describe 'homedir' do
      it { is_expected.to validate_presence_of(:homedir) }
    end
  end

  describe '#password=' do
    subject { FtpAccount.new(password: 'password') }

    it 'is set hashed password to password_digest' do
      expect(subject.password_digest).to match /\A\{sha256\}[a-zA-Z0-9\+\/=]+\z/
    end
  end

  describe '#after_create' do
    subject do
      described_class.create!(
        password: 'password',
        uid: 1000,
        gid: 1000,
        homedir: '/home/vagrant',
      )
    end

    it 'set username' do
      expect(subject.username).to eq "ftp-#{subject.id}"
    end
  end
end
