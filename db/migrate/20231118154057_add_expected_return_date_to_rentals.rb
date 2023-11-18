class AddExpectedReturnDateToRentals < ActiveRecord::Migration[6.0]
  def change
    add_column :rentals, :expected_return_date, :date
  end
end
