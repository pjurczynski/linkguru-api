FactoryGirl.define do
  sequence :url do |n|
    "http://some#{n}.example.com"
  end

  factory :link do
    url
    user
  end
end
