FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    username "Superbad"
    password "123456"
    password_confirmation "123456"
    email "fake@email.com"
    status "new"
    ip ""
  end
end