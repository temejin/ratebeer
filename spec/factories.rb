FactoryBot.define do
  factory :user do
    username { "Pekka" }
    password { "Foobar1" }
    password_confirmation { "Foobar1" }
  end

  factory :brewery do
    name { "anonymous" }
    year { 1900 }
  end

  factory :beer do
    name { "anonymous" }
    style { "Lager" }
    brewery # luodaan tehtaalla
  end

  factory :rating do
    score { 10 }
    beer # luodaan tehtaalla
    user # luodaan tehtaalla
  end
end
