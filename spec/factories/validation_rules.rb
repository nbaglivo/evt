FactoryBot.define do
  factory :validation_rule do
    validation_type { 'is_true' }
    user_field { Faker::Lorem.word }
    failure_message { Faker::Lorem.word }
    association :event, factory: :event
  end
end
