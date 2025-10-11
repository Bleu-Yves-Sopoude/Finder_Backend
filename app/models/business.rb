class Business < ApplicationRecord
  has_many :reviews, dependent: :destroy
  belongs_to :user

  validates :name, :description, :address, :category, presence: true
end
