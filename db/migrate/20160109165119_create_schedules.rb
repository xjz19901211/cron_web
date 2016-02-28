class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user, index: true
      t.references :work, index: true

      t.string :name
      t.string :cron
      t.text :input_args
      t.boolean :active

      t.timestamp :deleted_at
      t.index :deleted_at

      t.timestamps null: false
    end
  end
end
