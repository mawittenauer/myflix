Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name }
  active true
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end
