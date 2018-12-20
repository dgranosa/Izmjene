class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :token
      t.string :password

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
