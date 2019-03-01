class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', optional: true
  validates :body, length: {minimum: 10}


  def preview
    body.size > 20 ? body[0...20] + "..." : body
  end
  
end
