puts "🌱 Seeding database..."

# -------------------------
# USERS
# -------------------------
user = User.find_or_create_by!(email: "admin@example.com") do |u|
  u.name = "Admin User"
  u.password = "password"
end

# -------------------------
# BUSINESSES — BOUAKÉ (FORMAT 2 OK)
# -------------------------
business_data = [
  {
    name: "Seen Ranhotel Restaurant",
    description: "Cadre élégant, cuisine internationale et ivoirienne raffinée.",
    address: "Quartier Commerce, Rue Reine Pokou, Bouaké",
    category: "Restaurant",
    latitude: 7.6868,
    longitude: -5.0315
  },
  {
    name: "Maquis le 50tenaire",
    description: "Le maquis iconique de Bouaké pour l'attiéké-poisson.",
    address: "Quartier Air France 1, Bouaké",
    category: "Restaurant",
    latitude: 7.7025,
    longitude: -5.0152
  },
  {
    name: "Espace Sinai",
    description: "Spécialités locales et calme assuré.",
    address: "Air France 3, Bouaké",
    category: "Restaurant",
    latitude: 7.7081,
    longitude: -5.0089
  },
  {
    name: "Hotel Le Bahut",
    description: "Hôtel avec piscine, calme et sécurisé.",
    address: "Quartier Soukoura, Bouaké",
    category: "Hotel",
    latitude: 7.6744,
    longitude: -5.0356
  },
  {
    name: "Hôtel Cauris d'Or",
    description: "Modernité au cœur du Gbeke.",
    address: "Avenue de la Fraternité, Bouaké",
    category: "Hotel",
    latitude: 7.6892,
    longitude: -5.0247
  },
  {
    name: "Sococe Bouaké",
    description: "Centre commercial majeur.",
    address: "Route de Béoumi, Bouaké",
    category: "Supermarche",
    latitude: 7.6958,
    longitude: -5.0421
  },
  {
    name: "NASCO Electronics",
    description: "Électroménager et High-Tech.",
    address: "Quartier Commerce, Bouaké",
    category: "Boutique",
    latitude: 7.6875,
    longitude: -5.0298
  },
  {
    name: "Pharmacie du Marché de Gros",
    description: "Pharmacie 24h/24 près du marché de gros.",
    address: "Quartier Dougouba, Bouaké",
    category: "Pharmacie",
    latitude: 7.7122,
    longitude: -5.0255
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

puts "✅ #{Business.count} commerces géolocalisés à Bouaké créés."
