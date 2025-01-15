class UserSerializer
  include JSONAPI::Serializer
  
  attributes :id, :email, :name, :username, :created_at
  
  attribute :token do |user|
    response = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    response.first
  end
end
