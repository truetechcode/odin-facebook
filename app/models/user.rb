class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  has_many :sent_requests, class_name: 'FriendRequest', foreign_key: 'requestor_id'
  has_many :received_requests, class_name: 'FriendRequest', foreign_key: 'requestee_id' 
end
