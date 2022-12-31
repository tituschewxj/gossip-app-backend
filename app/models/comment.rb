class Comment < ApplicationRecord
    belongs_to :post, optional: false
    # belongs_to :user

    # belongs_to :parent, class_name: 'Comment', optional: false
    validates :content, :author, presence: true
    # has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
end
