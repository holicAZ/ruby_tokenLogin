class AddRefAccountFromUser < ActiveRecord::Migration[7.1]
  def change
    add_reference :accounts, :user, foreign_key: true
    change_column_default :accounts, :balance, 0
  end
end
