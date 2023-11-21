class Reader < User
    has_many :rentals
    has_many :books, through: :rentals
end