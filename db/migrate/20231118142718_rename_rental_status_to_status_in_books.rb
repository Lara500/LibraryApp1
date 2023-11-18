class RenameRentalStatusToStatusInBooks < ActiveRecord::Migration[6.0]
  def change
    rename_column :books, :rental_status, :status
  end
end