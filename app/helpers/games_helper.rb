module GamesHelper
  def gravatar_for(email, options)
    gravatar_id = Digest::MD5::hexdigest(email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: email, class: "gravatar")
  end

  def render_cell(cell, x, y, render_link)
    if cell.class.to_s == 'GameEngine::Atom'
      if cell.ship.type == 'carrier'
        render_link ? cell_link('[c]', x, y) : '[c]'
      elsif cell.ship.type == 'battle ship'
        render_link ? cell_link('[b]', x, y) : '[b]'
      elsif cell.ship.type == 'destroyer'
        render_link ? cell_link('[d]', x, y) : '[d]'
      elsif cell.ship.type == 'submarine'
        render_link ? cell_link('[s]', x, y) : '[s]'
      elsif cell.ship.type == 'patrol boat'
        render_link ? cell_link('[p]', x, y) : '[p]'
      end
    elsif cell.class.to_s == 'GameEngine::Salvo'
      '///'
    elsif cell.class.to_s == 'GameEngine::Hit'
      '[x]'
    else
      render_link ? cell_link('ooo', x, y) : 'ooo'
    end
  end

  private
    def cell_link(character, x, y)
      link_to(character, {:controller => "games", :action => "update", :x => x, :y => y }, { :method => :patch })
    end
end

