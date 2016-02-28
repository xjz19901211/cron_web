class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :role
      t.string :provider
      t.string :provider_id

      t.timestamps null: false

      t.index :email, unique: true
      t.index [:provider, :provider_id], unique: true
    end
  end
end
