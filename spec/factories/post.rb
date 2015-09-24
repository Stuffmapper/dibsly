include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :post do
    status "new"
    ip ""
    description 'shoes'
    latitude 0
    longitude 0
  end
end

