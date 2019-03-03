class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', optional: true
  belongs_to :post
  validates :body, length: {in: 1..255}, format: {without: /\A\s+\z/}
end
