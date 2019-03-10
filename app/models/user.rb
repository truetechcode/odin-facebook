class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_many :sent_requests, class_name: 'FriendRequest',
    foreign_key: 'requestor_id', dependent: :destroy
  has_many :received_requests, class_name: 'FriendRequest',
    foreign_key: 'requestee_id', dependent: :destroy

  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships, class_name: 'User'
  has_many :posts, foreign_key: 'author_id', dependent: :nullify
  has_many :comments, foreign_key: 'author_id', dependent: :nullify

  validates :name, length: {in: 3..255}

  def exists_request? user2
    self.received_requests.find_by(requestor_id: user2.id) ||
      self.sent_requests.find_by(requestee_id: user2.id)
  end

  def feed
    Post.where('author_id in (SELECT friend_id FROM friendships WHERE
      user_id = :user) or author_id = :user', user: self.id).order(created_at: :desc)
  end

  def member_since
    created_at.strftime("#{created_at.day.ordinalize} %b %Y")
  end

  def last_activity
    last_activity_date =  Post.find_by_sql("
      SELECT max(updated_at) AS updated_at
      FROM posts
      WHERE author_id = #{id}
      ")[0].updated_at
    if last_activity_date
      last_activity_date.strftime("#{last_activity_date.day.ordinalize} %b %Y")
    else
      updated_at.strftime("#{updated_at.day.ordinalize} %b %Y")
    end
  end

  def not_friend_list
    User.all.where('id <> :user AND
      id NOT IN (SELECT friend_id FROM friendships WHERE user_id = :user)',
      user: id)
  end

  def last_post
    posts.last
  end


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name #assuming the user model has a name
      #user.image = auth.info.image #assuming the user model has an image
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
end
