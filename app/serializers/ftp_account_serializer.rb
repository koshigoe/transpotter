class FtpAccountSerializer < ActiveModel::Serializer
  attributes :id, :username, :uid, :gid, :homedir, :shell
end
