class AddCodeToBots < ActiveRecord::Migration
  def self.up
    add_column :bots, :code, :integer
  end

  def self.down
    remove_column :bots, :code
  end
end
