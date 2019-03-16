class Pic < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_one_attached :image
  has_many :comments, as: :commentable, dependent: :destroy

end
