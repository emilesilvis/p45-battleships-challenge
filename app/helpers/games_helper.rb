module GamesHelper
  def gravatar_for(email, options)
    gravatar_id = Digest::MD5::hexdigest(email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: email, class: "gravatar")
  end
end

