class AddAccountPhoneUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :accounts, :phone, :unique => true
  end

  def self.down
    remove_index :accounts, :phone
  end
end
