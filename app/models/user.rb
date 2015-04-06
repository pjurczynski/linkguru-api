class User < ActiveRecord::Base
  has_many :links

  def generate_token!
    update_attribute :token, SecureRandom.hex(8)
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
