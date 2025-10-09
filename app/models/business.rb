class Business < ApplicationRecord
  belongs_to :user

  validates :name, :description, :address, :category, presence: true
end
