class CreateSubscription < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
        t.string :email, null: false,
                         index: { unique: true }
        t.string :shift
        t.string :klass
    end
  end
end
