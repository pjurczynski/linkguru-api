module Slack::API
  describe UserList do
    before { WebMock.allow_net_connect! }
    subject { described_class.new }

    it { expect(subject.call).to be_an Array }
  end
end
