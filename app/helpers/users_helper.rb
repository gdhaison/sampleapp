module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    image_tag Settings.gravatar_url, alt: user.name, class: "gravatar"
  end
end
