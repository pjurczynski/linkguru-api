FactoryGirl.define do
  factory :link do
    url { 'http://some.example.com' }
    user
  end
end
