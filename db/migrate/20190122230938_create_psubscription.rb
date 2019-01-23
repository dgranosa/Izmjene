class CreatePsubscription < ActiveRecord::Migration[5.2]
  def change
    create_table :psubscriptions do |t|
        t.string :name
        t.string :email, null: false,
                         index: { unique: true }
    end
  end
end
