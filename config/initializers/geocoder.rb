Geocoder.configure(
  # Geocoding options
  timeout: 5,                      # increase timeout so API has more time
  lookup: :nominatim,              # free OpenStreetMap geocoder
  units: :km,

  # Required by Nominatim (they reject requests without User-Agent)
  http_headers: {
    "User-Agent" => "FinderApp (email@example.com)"
  },

  # Don’t crash your app or seeds if API fails
  always_raise: [],                # disable raising Geocoder errors

  # Caching (optional but recommended)
  # cache: Redis.new,
  # cache_prefix: "geocoder:"
)
