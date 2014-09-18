FactoryGirl.define do
  factory :todo do
    title "title"
    status 0
    association :project
  end
end