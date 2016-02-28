class CreateUserLogs < ActiveRecord::Migration
  def change
    create_table :user_logs do |t|
      t.references :user, index: true

      t.string :action
      t.binary :params

      t.timestamps null: false
    end
  end
end
