class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :name
      t.integer :work_id
      t.string :cron
      t.boolean :active

      t.timestamps null: false
    end
  end
end
