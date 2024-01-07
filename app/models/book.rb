class Book < ApplicationRecord
    has_one_attached :image
    has_many :rentals
    has_many :readers, through: :rentals

    validates :title, :author, :description, :genre, :release_date, :publisher, :page_number, :translation, :status, :ISBN, presence: true
    
    def self.ransackable_attributes(auth_object = nil)
      %w[title author genre publisher ISBN]
    end
  
    def self.ransackable_associations(auth_object = nil)
      %w[image_attachment image_blob readers rentals]
    end


    def is_available
        status == "dostępna"
    end
end
