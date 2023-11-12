class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :description
      t.string :genre
      t.date :release_date
      t.string :publisher
      t.string :ISBN
      t.integer :page_number
      t.string :translation
      t.string :rental_status

      t.timestamps
    end
  end
end
