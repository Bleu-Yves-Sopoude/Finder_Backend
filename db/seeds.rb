puts "🌱 Seeding database..."

# -------------------------
# USERS
# -------------------------
user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.password = "password"
end

# -------------------------
# BUSINESSES (NYC — WITH COORDS)
# -------------------------
business_data = [
  {
    name: "Joe's Pizza",
    description: "Famous NYC pizza spot",
    address: "7 Carmine St, New York, NY",
    category: "Food",
    latitude: 40.7306,
    longitude: -73.9866
  },
  {
    name: "Central Park Cafe",
    description: "Cafe near Central Park",
    address: "Central Park, New York, NY",
    category: "Cafe",
    latitude: 40.7851,
    longitude: -73.9683
  },
  {
    name: "Brooklyn Coffee Roasters",
    description: "Artisan coffee in Brooklyn",
    address: "25 Jay St, Brooklyn, NY",
    category: "Coffee",
    latitude: 40.7044,
    longitude: -73.9867
  },
  {
    name: "Williamsburg Bar",
    description: "Trendy nightlife spot",
    address: "Williamsburg, Brooklyn, NY",
    category: "Bar",
    latitude: 40.7081,
    longitude: -73.9571
  }
]

business_data.each do |attrs|
  Business.find_or_create_by!(name: attrs[:name]) do |b|
    b.description = attrs[:description]
    b.address     = attrs[:address]
    b.category    = attrs[:category]
    b.latitude    = attrs[:latitude]
    b.longitude   = attrs[:longitude]
    b.user        = user
  end
end

# -----------------------
