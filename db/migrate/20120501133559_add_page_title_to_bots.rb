class AddPageTitleToBots < ActiveRecord::Migration
  def self.up
    add_column :bots, :page_title, :string
  end

  def self.down
    remove_column :bots, :page_title
  end
end
