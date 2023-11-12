class Book < ApplicationRecord
    has_many :rentals
    has_many :readers, through: :rentals
end
