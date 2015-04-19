require 'rails_helper'

module Slack
  describe LinksController do
    let(:params) do
      {
        "token"=>"2H4D65bKXHlMIdrQOdoxCvPG",
        "team_id"=>"T0251EZGA",
        "team_domain"=>"netguru",
        "service_id"=>"4484363840",
        "channel_id"=>"C02KPPDS7",
        "channel_name"=>"sandbox",
        "timestamp"=>"1429281463.000014",
        "user_id"=>"U02J1P00M",
        "user_name"=>"szujekdobrarada",
        "text"=>"add link http://something.com",
        "trigger_word"=>"add link",
      }
    end

    describe '#create' do
      it 'should create a link'
    end
  end
end
