class AddProfileToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :profile, null: false, foreign_key: true, default: 3
  end
end
