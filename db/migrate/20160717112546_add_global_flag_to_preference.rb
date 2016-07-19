class AddGlobalFlagToPreference < ActiveRecord::Migration
  def change
    add_column :preferences, :global, :boolean, default: false
  end
end
