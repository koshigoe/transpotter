class AuthenticationSerializer < ActiveModel::Serializer
  attributes :id, :token
  type 'authentication'
end
