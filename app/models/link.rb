class Link < ActiveRecord::Base
  acts_as_taggable
  acts_as_votable

  default_scope { order(created_at: :desc) }

  belongs_to :user

  validates :user, :url, presence: true
end
