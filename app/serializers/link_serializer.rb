class LinkSerializer < ActiveModel::Serializer
  attributes :id, :description, :url, :tag_list, :score, :upVoted, :downVoted, :owned
  delegate :current_user, to: :scope

  has_one :user, serializer: UserSerializer, key: :owner

  def owned
    object.user == current_user
  end

  def score
    object.weighted_score
  end

  def upVoted
    return true if owned
    object.votes_for(current_user).first.try(:vote_flag) == true
  end

  def downVoted
    return true if owned
    object.votes_for(current_user).first.try(:vote_flag) == false
  end
end
