class CreateUsersV2 < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
        t.string :username
        t.string :fullname
        t.string :email
        t.string :role, default: ''
        t.string :password_digest
        t.string :token, null: false,
                         default: '',
                         index: { unique: true }
    end
  end
end
