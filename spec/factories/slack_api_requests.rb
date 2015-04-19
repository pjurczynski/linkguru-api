FactoryGirl.define do
  factory :slack_api_request, class: Hash do
    skip_create

    token { Rails.application.secrets.slack_outgoing_token }
    team_id "T0251EZGA"
    team_domain "netguru"
    service_id "4484363840"
    channel_id "C02KPPDS7"
    channel_name "sandbox"
    timestamp "1429281463.000014"
    user_id "U02J1P00M"
    user_name 'fictional'
    text "add link <http://something.co> some description #tag #tag2"
    trigger_word "add link"

    initialize_with { attributes.stringify_keys }
  end
end
