class Book < ApplicationRecord
    has_many :rentals
    has_many :readers, through: :rentals

    def is_available
        # Tutaj dodaj logikę określającą, czy książka jest dostępna.
        # Przykładowo, możesz sprawdzić, czy `rental_status` jest równy "Dostępna".
        status == "dostępna"
    end
end
