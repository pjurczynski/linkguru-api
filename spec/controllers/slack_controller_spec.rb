require 'rails_helper'

describe SlackController do
  include_context 'szujek is a member'

  describe '#authenticate_slack!' do
    subject { described_class.new }
    describe 'authentication passes' do
      before do
        subject.params = {
          token: Rails.application.secrets.slack_outgoing_token,
          user_name: slack_szujek['name'],
          trigger_word: Rails.application.secrets.trigger_words.fetch('list').first,
        }
      end

      it { expect(subject.current_slack_user).to eq local_szujek }
      it { expect(subject.token_valid?).to be_truthy }
      it { expect(subject.trigger_word_valid?).to be_truthy }

      describe 'accepts all keywords' do
        Rails.application.secrets.trigger_words.fetch('list').each do |keyword|
          before { subject.params[:trigger_word] = keyword }

          it "accepts `#{keyword}` keyword" do
            expect(subject.trigger_word_valid?).to be_truthy
          end
        end
      end
    end
  end
end
