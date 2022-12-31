class Post < ApplicationRecord
    # belongs_to: user
    has_many :comments, dependent: :destroy
    validates :content, :title, :author, presence: true
end
