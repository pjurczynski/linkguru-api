class User < ActiveRecord::Base
  has_many :links

  scope :logged, -> { where('token IS NOT NULL') }

  def generate_token!
    update_attribute :token, SecureRandom.hex(8)
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
