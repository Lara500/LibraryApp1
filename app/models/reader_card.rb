class ReaderCard < ApplicationRecord
  belongs_to :user
  validates :number, presence: true
  validates :code, presence: true
  validate :user_must_be_a_reader

  private

  def user_must_be_a_reader
    errors.add(:user, "musi być czytelnikiem") unless user.type == "Reader"
  end
end
