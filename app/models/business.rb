class Business < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user, optional: true


  validates :name, :description, :address, :category, presence: true

  geocoded_by :address
  after_validation :geocode, if: -> { will_save_change_to_address? && Rails.env.production? }


  def full_address
    "#{address}"
  end

  scope :search, ->(term) {
  where(
    "name ILIKE :q OR category ILIKE :q",
    q: "%#{term}%"
  ) if term.present?
}

scope :with_min_rating, ->(rating) {
  return unless rating.present?

  left_joins(:reviews)
    .group("businesses.id")
    .having("COALESCE(AVG(reviews.rating), 0) >= ?", rating)
}
end
