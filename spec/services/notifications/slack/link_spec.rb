require 'rails_helper'

module Notifications::Slack
  describe Link do
    let(:user) { build(:user) }
    let(:link) { build(:link, user: user) }

    subject { described_class.new(link) }

    it 'slack responds with OK' do
      expect(subject.call.code).to eq '200'
    end

    context 'stubbed api calls' do
      before do
        stub_request(:post, Rails.application.secrets.slack_webhook)
        allow(subject).to receive(:send_message).and_call_original
      end

      it 'includes a link' do
        subject.call
        expect(subject).to have_received(:send_message).with(/#{link.url}/)
      end
    end
  end
end
