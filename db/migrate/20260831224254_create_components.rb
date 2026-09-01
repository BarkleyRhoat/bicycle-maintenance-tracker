class CreateComponents < ActiveRecord::Migration[8.1]
  def change
    create_table :components do |t|
      t.string :name
      t.string :component_type
      t.integer :expected_lifespan_km

      t.timestamps
    end
  end
end
