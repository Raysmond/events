FactoryGirl.define do
  factory :project do
    name "project"
    association :user
    association :team
  end
end