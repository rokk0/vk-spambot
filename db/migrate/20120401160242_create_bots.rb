class CreateBots < ActiveRecord::Migration
  def self.up
    create_table :bots do |t|
      t.integer :user_id
      t.string :email
      t.string :password
      t.string :bot_type
      t.string :page
      t.string :page_hash
      t.text :message
      t.integer :count
      t.string :interval

      t.timestamps
    end
    add_index :bots, :user_id
  end

  def self.down
    drop_table :bots
  end
end
