class Review < ApplicationRecord
  has_many_attached :photos


  belongs_to :user
  belongs_to :business

  validates :rating,  presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true
end
