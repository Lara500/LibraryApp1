class Rental < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rental_status, presence: true
end
