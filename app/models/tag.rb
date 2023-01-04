class Tag < ApplicationRecord
  has_many :posts_tags, through: :posts_tags
  validates :name, presence: true, uniqueness: true
end
