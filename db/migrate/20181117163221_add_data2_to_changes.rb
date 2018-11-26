class AddData2ToChanges < ActiveRecord::Migration[5.2]
  def change
      add_column :changes, :data2, :string
  end
end
