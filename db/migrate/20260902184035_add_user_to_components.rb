class AddUserToComponents < ActiveRecord::Migration[8.1]
  def up
    add_reference :components, :user, foreign_key: true

    if Component.any?
      owner = User.first || User.create!(
        name: "Placeholder",
        email: "placeholder@example.com",
        password: "password123",
        password_confirmation: "password123"
      )
      Component.update_all(user_id: owner.id)
    end

    change_column_null :components, :user_id, false
  end

  def down
    remove_reference :components, :user
  end
end
