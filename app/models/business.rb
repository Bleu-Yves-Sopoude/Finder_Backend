class Business < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  validates :name, :description, :address, :category, presence: true

  geocoded_by :full_address
  after_validation :geocode, if: :will_save_change_to_address?

  def full_address
    "#{address}"
  end

end
