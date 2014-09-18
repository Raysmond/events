FactoryGirl.define do
  factory :project do
    name "project"
    # users [User.create(:user), User.create(:user)]
    association :user
    association :team
  end
end