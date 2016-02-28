class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.references :user, index: true

      t.string :name
      t.text :input_args
      t.string :code_lang
      t.text :code

      t.timestamp :deleted_at
      t.index :deleted_at

      t.timestamps null: false
    end
  end
end
