class RemoveTimeFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :time, :datetime
  end
end
