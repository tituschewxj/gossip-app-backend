class Comment < ApplicationRecord
    belongs_to :post, optional: false
    belongs_to :profile, optional: false
    validates :content, :author, presence: true
    # belongs_to :parent, class_name: 'Comment', optional: false
    # has_many :replies, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
end
