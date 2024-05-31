class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.string :stripe_product_id, null: false
      t.integer :quantity, null: false, default: 1
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
