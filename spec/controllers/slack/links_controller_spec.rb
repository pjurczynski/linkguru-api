require 'rails_helper'

module Slack
  describe LinksController do
    include_context 'szujek is a member'

    let!(:outbound_request) do
      stub_request(:post, Rails.application.secrets.slack_webhook)
    end

    describe "#create" do
      let(:params) do
        build(
          :slack_api_request,
          user_name: slack_szujek['name'],
          text: "add link <http://something.co> some description #tag #tag2",
          trigger_word: "add link"
        )
      end

      subject { post :create, params }
      it { expect{ subject }.to change{ Link.count }.by(1) }
      it { expect{ subject }.to change{ Link.first.url }.to('http://something.co') }
      it { expect{ subject }.to change{ Link.first.tags.count }.to(2) }
      it { expect{ subject }.to change{ Link.first.tags.pluck(:name) }.to(%w[tag2 tag]) }
      it "returns success message in json" do
        expect(subject.body)
          .to eq({ text: I18n.t('slack.links.create_success') }.to_json)
      end

      context "Link couldn't be saved" do
        let(:params) do
          build(
            :slack_api_request,
            user_name: slack_szujek['name'],
            text: "add link but no link!",
            trigger_word: "add link"
          )
        end

        it "returns failing message in json" do
          expect(subject.body)
            .to eq({ text: I18n.t('slack.links.create_failed') }.to_json)
        end
      end
    end

    describe "#last_upvote" do
      let!(:old_link) { create(:link) }
      let!(:fresh_link) { create(:link) }
      let(:params) do
        build(
          :slack_api_request,
          "user_name" => slack_szujek['name'],
          "text" => "upvote",
          "trigger_word" => "upvote",
        )
      end
      subject { post :last_upvote, params }

      it "upvotes newly added link" do
        expect{ subject }.to change{ fresh_link.votes_for.count }.by(1)
      end

      it "other links doesn't change" do
        expect{ subject }.not_to change{ old_link.votes_for.count }
      end

      it "sends a message to slack channel" do
        subject
        expect(outbound_request)
          .to have_requested(:post, Rails.application.secrets.slack_webhook)
      end
    end

    describe "#last_downvote" do
      let!(:old_link) { create(:link) }
      let!(:fresh_link) { create(:link) }
      let(:params) do
        build(
          :slack_api_request,
          "user_name" => slack_szujek['name'],
          "text" => "downvote",
          "trigger_word" => "downvote",
        )
      end
      subject { post :last_downvote, params }

      it "downvotes newly added link" do
        expect{ subject }.to change{ fresh_link.get_downvotes.count }.by(1)
      end

      it "other links doesn't change" do
        expect{ subject }.not_to change{ old_link.get_downvotes.count }
      end

      it "sends a message to slack channel" do
        subject
        expect(outbound_request)
          .to have_requested(:post, Rails.application.secrets.slack_webhook)
      end
    end
  end
end
