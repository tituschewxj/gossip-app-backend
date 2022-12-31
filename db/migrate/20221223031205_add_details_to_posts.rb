class AddDetailsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :author, :string
    add_column :posts, :time, :datetime
  end
end
