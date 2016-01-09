class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.text :input_args
      t.string :code_lang
      t.text :code

      t.timestamps null: false
    end
  end
end
