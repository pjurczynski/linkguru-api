class Link < ActiveRecord::Base
  acts_as_taggable
  acts_as_votable
end