module GamesHelper
  def gravatar_for(email, options)
    gravatar_id = Digest::MD5::hexdigest(email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: email, class: "gravatar")
  end

  def render_cell(game, cell, x, y, render_link)
    if cell.nil?
      render_link ? cell_link(game, 'ooo', x, y) : 'ooo'
    else
      if cell.manifestation.class.to_s == 'GameEngine::Ship'
        cell_str = "[#{cell.manifestation.type.to_s[0]}]"
        render_link ? cell_link(game, cell_str, x, y) : cell_str
      elsif cell.manifestation == :salvo
        '///'
      elsif cell.manifestation == :hit
        '[x]'
      end
    end
  end

  private

  def cell_link(game, character, x, y)
    link_to(character, {controller: "games", action: "update", x: x, y: y, id: game.id }, { method: :patch }).tap { |x| p x }
  end
end

