module ApplicationHelper
 def gravatar_for(user, option, design)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = option
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.email, class: design)
  end
end
