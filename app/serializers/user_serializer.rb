class UserSerializer < ActiveModel::Serializer
  attributes :id, :token, :email, :name
end
