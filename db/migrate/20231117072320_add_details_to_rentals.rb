class AddDetailsToRentals < ActiveRecord::Migration[7.0]
  def change
    add_column :rentals, :rental_status, :string
    add_column :rentals, :rental_date, :datetime
    add_column :rentals, :return_date, :date
    add_column :rentals, :overdue, :boolean, default: false
  end
end
