FactoryGirl.define do
  factory :todo do
    
    association :user
    association :events
  end
end