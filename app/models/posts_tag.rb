class PostsTag < ApplicationRecord
  belongs_to :post, presence: true
  belongs_to :tag, presence: true
end
