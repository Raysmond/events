FactoryGirl.define do
  factory :comment do
    content "comment"
    association :user
    association :todo
  end
end