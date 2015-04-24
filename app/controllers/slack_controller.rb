class SlackController < ActionController::API
  rescue_from StandardError do
    render json: { text: I18n.t('status.total_failure') }
  end

  def authenticate_slack!
    unless slack_user_authenticated?
      render json: { text: I18n.t('status.unauthorized') }
    end
  end

  def slack_user_authenticated?
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
