class CreateChange < ActiveRecord::Migration[5.2]
  def change
    create_table :changes do |t|
        t.date :date, null: false
        t.string :shift, null: false
        t.string :data

        t.timestamps null: false
    end
  end
end
