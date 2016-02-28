class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true

      t.integer :work_id, index: true
      t.integer :schedule_id, index: true
      t.text :output
      t.string :status

      t.timestamps null: false
    end
  end
end
