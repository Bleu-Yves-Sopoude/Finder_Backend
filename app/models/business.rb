class Business < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user
  has_many_attached :photos

  validates :name, :description, :address, :category, presence: true
end
