class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user, index: true

      t.string :name
      t.integer :work_id
      t.string :cron
      t.text :input_args
      t.boolean :active

      t.timestamps null: false
    end
  end
end
