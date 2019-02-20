class AddPublishedToChanges < ActiveRecord::Migration[5.2]
  def change
    add_column :changes, :published, :boolean, default: false
  end
end
