class Post < ApplicationRecord
    belongs_to :profile, optional: false
    has_many :comments, dependent: :destroy

    has_many :posts_tags, dependent: :destroy
    has_many :tags, through: :posts_tags
    
    validates :content, :title, :author, presence: true
end
