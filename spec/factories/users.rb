FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "name#{n}" }
    sequence(:email){|n| "email#{n}@tower_events.com" }
    password 'password'
    password_confirmation 'password'
    created_at 100.days.ago
    current_team Team.create!(name: "team")
  end
end