class Post < ApplicationRecord
    belongs_to :profile, optional: false
    has_many :comments, dependent: :destroy
    has_many :posts, through: :posts_tags
    validates :content, :title, :author, presence: true
end
