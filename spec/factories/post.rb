include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :post do
    status "new"
    ip ""
    image { fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png') }
  end
end

