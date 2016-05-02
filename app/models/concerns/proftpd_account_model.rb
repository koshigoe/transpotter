require 'digest/sha2'
require 'base64'

module ProFTPDAccountModel
  extend ActiveSupport::Concern

  included do
    validates :password, presence: true, on: :create
    validates :uid, presence: true, numericality: { allow_blank: true }
    validates :gid, presence: true, numericality: { allow_blank: true }
    validates :homedir, presence: true

    attr_readonly :username
    attr_accessor :password

    before_save do
      self.password_digest = "{sha256}#{Base64.strict_encode64(Digest::SHA256.digest(password))}" if password.present?
    end

    after_create do
      scheme = self.class.name.underscore.split('_').first
      self.class.where(id: id).update_all("username = CONCAT('#{scheme}-', id)")
      self.username = "#{scheme}-#{id}"
      clear_attribute_changes([:username])
    end
  end
end
