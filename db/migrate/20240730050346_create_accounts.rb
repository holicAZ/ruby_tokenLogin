class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.text :name
      t.text :account_num
      t.text :password
      t.integer :balance
      t.timestamps
    end
  end
end
