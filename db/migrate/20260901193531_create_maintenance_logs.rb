class CreateMaintenanceLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_logs do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :component, foreign_key: true
      t.date :service_date, null: false
      t.string :description, null: false
      t.integer :km_at_service, default: 0, null: false

      t.timestamps
    end
  end
end
