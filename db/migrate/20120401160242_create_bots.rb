class CreateBots < ActiveRecord::Migration
  def self.up
    create_table :bots do |t|
      t.string  :bot_type
      t.string  :page
      t.string  :page_title
      t.string  :page_hash
      t.string  :interval
      t.text    :message
      t.integer :account_id

      t.timestamps
    end

    add_index :bots, :account_id
  end

  def self.down
    drop_table :bots
  end
end
