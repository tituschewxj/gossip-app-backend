class AddProfileToComments < ActiveRecord::Migration[7.0]
  def change
    add_reference :comments, :profile, null: false, foreign_key: true, default: 3
  end
end
