class String
  def to_html
    RedCloth.new(self).to_html
  end

  def auto_link
    self.gsub(/<((https?|ftp|irc):[^'">\s]+)>/xi, %Q{<a href="\\1">\\1</a>})
  end

  def wiki_link
    self.gsub(/([A-Z][a-z]+[A-Z][A-Za-z0-9]+)/) do |page|
      %Q{<a class="#{Page.css_class_for(page)}" href="/#{page}">#{page.titleize}</a>}
    end
  end

  def titleize
    self.gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').gsub(/([a-z\d])([A-Z])/,'\1 \2')
  end

  def without_ext
    self.sub(File.extname(self), '')
  end
end