class CreateBikeComponents < ActiveRecord::Migration[8.1]
  def change
    create_table :bike_components do |t|
      t.references :bike, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true
      t.date :installed_on, null: false
      t.integer :current_km, default: 0, null: false

      t.timestamps
    end

    add_index :bike_components, %i[bike_id component_id], unique: true
  end
end
