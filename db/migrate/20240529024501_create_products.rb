class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :tags
      t.datetime :createdAt
      t.datetime :updatedAt
      t.float :price

      t.timestamps
    end
  end
end
