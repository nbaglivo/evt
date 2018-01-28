FactoryGirl.define do
  factory :event do
    name { Faker::Lorem.word }
    date { Faker::Date.between(2.days.ago, Date.today)  }
    association :owner, factory: :user
  end
end
