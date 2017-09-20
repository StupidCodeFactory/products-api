FactoryGirl.define do
  factory :product do
    name           { Faker::Commerce.product_name }
    description    { Faker::Hipster.paragraphs(rand(1..5)).join("\n") }
    price_in_cents { (Faker::Commerce.price * 100).to_i }
  end
end
