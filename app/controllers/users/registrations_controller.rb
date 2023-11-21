# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |user|
      card_number = generate_unique_card_number
      card_code = SecureRandom.hex(4)  # lub inna logika generowania kodu

      # Stworzenie powiązanej karty czytelnika
      user.build_reader_card(number: card_number, code: card_code)
      user.save
    end
  end

  private

  def generate_unique_card_number
    # Logika generowania unikalnego numeru karty
    loop do
      number = SecureRandom.random_number(1000..9999)
      break number unless ReaderCard.exists?(number: number)
    end
  end
end
  