class RemoveTimeFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :time, :datetime
  end
end
