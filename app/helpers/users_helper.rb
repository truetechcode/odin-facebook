module UsersHelper

  def gravatar_for(user, size:60)
    if user.avatar.attached?
      #avatar_url = url_for(user.avatar.variant(resize_to_limit: [100,100]))
      avatar_url = user.avatar.variant(resize:"#{size}x#{size}!")
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      avatar_url =
        "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=wavatar"

    end
    image_tag(avatar_url, alt:user.name,class: "gravatar")
  end
end
