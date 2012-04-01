class AddStateToBots < ActiveRecord::Migration
  def change
    add_column :bots, :state, :string

  end
end
