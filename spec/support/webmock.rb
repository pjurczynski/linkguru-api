require 'webmock/rspec'
RSpec.configure do |config|
  config.before do
    WebMock.allow_net_connect!
  end
end
