class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.integer :user_id
      t.string :email
      t.string :password
      t.integer :code
      t.boolean :approved

      t.timestamps
    end
    add_index :accounts, :user_id
  end

  def self.down
    drop_table :accounts
  end
end
