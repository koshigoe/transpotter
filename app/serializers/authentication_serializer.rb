class AuthenticationSerializer < ActiveModel::Serializer
  attributes :id, :token
  type 'authentications'
end
