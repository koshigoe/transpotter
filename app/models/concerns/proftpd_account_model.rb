require 'digest/sha2'
require 'base64'

module ProFTPDAccountModel
  extend ActiveSupport::Concern

  included do
    validates :password, presence: true, on: :create
    validates :homedir, presence: true

    attr_readonly :username
    attr_accessor :password

    before_save do
      self.password_digest = "{sha256}#{Base64.strict_encode64(Digest::SHA256.digest(password))}" if password.present?
      self.uid = Rails.configuration.x.proftpd_account.default_uid
      self.gid = Rails.configuration.x.proftpd_account.default_gid
    end

    after_create do
      scheme = self.class.name.underscore.split('_').first
      self.username = "#{scheme}-#{id}"
      self.homedir = "#{Rails.configuration.x.proftpd_account.default_homedir}/#{username}"
      self.class.where(id: id).update_all("username = '#{username}', homedir = '#{homedir}'")
      clear_attribute_changes([:username, :homedir])
    end
  end
end
