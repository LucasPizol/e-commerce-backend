class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :description
      t.string :tags, null: false
      t.float :price, null: false

      t.timestamps
    end
  end
end
