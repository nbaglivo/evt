FactoryBot.define do
  factory :event do
    name { Faker::Lorem.word }
    date { Faker::Date.between(2.days.ago, Date.today)  }
    association :owner, factory: :user
    attendees { [{ email: 'nico@nico.com' }] }
  end
end
