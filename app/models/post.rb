class Post < ApplicationRecord
    belongs_to :profile, optional: false
    has_many :comments, dependent: :destroy
    validates :content, :title, :author, presence: true
end
