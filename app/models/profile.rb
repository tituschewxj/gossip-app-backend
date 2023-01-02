class Profile < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :username, presence: true, uniqueness: true
end
