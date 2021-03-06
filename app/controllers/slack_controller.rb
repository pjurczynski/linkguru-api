class SlackController < ActionController::API
  def authenticate_slack!
    current_slack_user.present? && token_valid? && trigger_word_valid?
  end

  def current_slack_user
    return @current_slack_user if @current_slack_user.present?
    users = Slack::API::UserList.new.call
    slack_user = users.find { |user| user['name'] == params[:user_name] }
    @current_slack_user = User.find_by_email(slack_user['profile']['email'])
  end

  def token_valid?
    params.fetch(:token) == Rails.application.secrets.slack_outgoing_token
  end

  def trigger_word_valid?
    Rails.application.secrets.trigger_words.fetch('list').include?(
      params[:trigger_word]
    )
  end
end
