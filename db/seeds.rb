# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end




# Find or create a user (you can adjust this to your existing auth system)
user2 =User.create!(email: "admin@example.com", password: "password")

# Create sample businesses
Business.create!([
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
])
