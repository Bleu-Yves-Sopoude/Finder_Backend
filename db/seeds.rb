# This file seeds initial data for all environments.
# It is written to be idempotent — safe to run multiple times.

# -------------------------
# USERS
# -------------------------

user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.password = "password"
end

# -------------------------
# BUSINESSES
# -------------------------

business_data = [
  {
    name: "Joe's Coffee",
    description: "A cozy coffee shop with a great selection of brews.",
    address: "123 Bean St, Brewtown",
    category: "Cafe",
    user: user
  },
  {
    name: "Techie Fix",
    description: "Repair services for all your gadgets and devices.",
    address: "456 Silicon Ave, Tech City",
    category: "Repair",
    user: user
  },
  {
    name: "Green Leaf Grocery",
    description: "Organic produce and natural groceries.",
    address: "789 Garden Rd, Farmville",
    category: "Grocery",
    user: user
  }
]

business_data.each do |attrs|
  record = Business.find_or_create_by!(name: attrs[:name]) do |b|
    b.description = attrs[:description]
    b.address = attrs[:address]
    b.category = attrs[:category]
    b.user = attrs[:user]
  end

  # Trigger geocoding only if no coordinates yet
  if record.latitude.blank? || record.longitude.blank?
    record.geocode
    record.save!
  end
end

# -------------------------
# TEST BUSINESS
# -------------------------

test_business = Business.find_or_create_by!(name: "Test Cafe") do |b|
  b.description = "A testing-only cafe for geocoding demonstration."
  b.address     = "123 Market St, San Francisco, CA"
  b.category    = "Cafe"
  b.user        = user
end


# Geocode if needed
if test_business.latitude.blank? || test_business.longitude.blank?
  test_business.geocode
  test_business.save!
end

puts "🌱 Seed complete: #{User.count} users, #{Business.count} businesses."
