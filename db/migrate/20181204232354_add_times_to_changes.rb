class AddTimesToChanges < ActiveRecord::Migration[5.2]
  def change
      add_column :changes, :starttime, :string
      add_column :changes, :endtime, :string
  end
end
