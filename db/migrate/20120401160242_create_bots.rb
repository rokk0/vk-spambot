class CreateBots < ActiveRecord::Migration
  def self.up
    create_table :bots do |t|
      t.integer :account_id
      t.string :bot_type
      t.string :page
      t.string :page_title
      t.string :page_hash
      t.text :message
      t.integer :count
      t.string :interval

      t.timestamps
    end
    add_index :bots, :account_id
  end

  def self.down
    drop_table :bots
  end
end
