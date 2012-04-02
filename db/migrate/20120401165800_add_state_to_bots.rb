class AddStateToBots < ActiveRecord::Migration
  def self.up
    add_column :bots, :state, :string
  end

  def self.down
    remove_column :bots, :state
  end
end
