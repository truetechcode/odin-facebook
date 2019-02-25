class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :sent_requests, class_name: 'FriendRequest',
    foreign_key: 'requestor_id', dependent: :destroy
  has_many :received_requests, class_name: 'FriendRequest',
    foreign_key: 'requestee_id', dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, class_name: 'User'

  validates :name, length: {in: 3..255}

  def exists_request? user2
    self.received_requests.find_by(requestor_id: user2.id) ||
      self.sent_requests.find_by(requestee_id: user2.id)
  end
end
