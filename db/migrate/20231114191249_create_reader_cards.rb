class CreateReaderCards < ActiveRecord::Migration[7.0]
  def change
    create_table :reader_cards do |t|
      t.string :number
      t.string :code
      t.references :reader, null: false, foreign_key: true

      t.timestamps
    end
  end
end
