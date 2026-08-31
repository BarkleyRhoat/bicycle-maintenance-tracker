class CreateBikes < ActiveRecord::Migration[8.1]
  def change
    create_table :bikes do |t|
      t.string :name
      t.string :brand
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
