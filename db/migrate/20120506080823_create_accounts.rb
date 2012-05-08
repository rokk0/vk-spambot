class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string  :phone
      t.string  :password
      t.boolean :approved
      t.integer :user_id
      t.integer :bots_allowed, :default => 5

      t.timestamps
    end

    add_index :accounts, :user_id
    add_index :accounts, :phone, :unique => true
  end

  def self.down
    drop_table :accounts
  end
end
