class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :role
      t.string :provider

      t.timestamps null: false

      t.index :email
    end
  end
end
