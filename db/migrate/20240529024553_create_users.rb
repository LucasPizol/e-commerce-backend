class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :document, null: false
      t.string :password_digest
      t.string :role, null: false, default: 'user'

      t.timestamps
    end
  end
end
