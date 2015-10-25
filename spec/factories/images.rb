FactoryGirl.define do
  factory :image do
      image { fixture_file_upload(Rails.root.join("spec/factories/shoes.png"), 'image/png') }
  end

end
