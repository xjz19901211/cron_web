class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true
      t.references :work, index: true
      t.references :schedule, index: true

      t.text :output
      t.string :status

      t.timestamps null: false
    end
  end
end
