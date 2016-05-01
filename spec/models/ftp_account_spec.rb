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

    describe 'password' do
      context 'on create' do
        it { is_expected.to validate_presence_of(:password) }
      end

      context 'on update' do
        subject { create(:ftp_account) }
        it { is_expected.to allow_value('').for(:password) }
      end
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

  describe '#before_create' do
    subject do
      FtpAccount.create!(
        password: 'password',
        uid: Rails.configuration.x.ftp_account.default_uid,
        gid: Rails.configuration.x.ftp_account.default_gid,
        homedir: Rails.configuration.x.ftp_account.default_homedir,
      )
    end

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
      expect(subject.reload.username).to eq "ftp-#{subject.id}"
    end

    it 'is clean username' do
      expect(subject.username_changed?).to eq false
    end
  end
end
