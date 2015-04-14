FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    sequence :username do |n|
        "Superbad#{n}"
    end
    password "123456"
    password_confirmation "123456"
    sequence :email do |n|
        "Superbad#{n}@email.com"
    end
    privacy_policy_agreement true

    status "new"
    ip ""
  end
end
