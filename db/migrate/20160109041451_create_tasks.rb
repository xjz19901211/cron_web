class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :work_id
      t.text :output

      t.timestamps null: false
    end
  end
end
