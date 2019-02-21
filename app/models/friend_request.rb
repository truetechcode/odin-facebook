class FriendRequest < ApplicationRecord
  belongs_to :requestor, class_name: 'User'
  belongs_to :requestee, class_name: 'User'

  validates :requestor, uniqueness: { scope: :requestee}


end
