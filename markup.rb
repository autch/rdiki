require 'rdoc/markup/simple_markup'
require 'rdoc/markup/simple_markup/to_html'
require 'template.rb'

module RDiki
  class Markup < SM::SimpleMarkup
    def handled_labeled_list(line, level, margin, offset, prefix)
      # escape when bracket name begins !, some scheme word, follows :
      return false if /^\[\!\w+:/ =~ prefix
      super
    end

    def initialize
      super
      #    add_word_pair("{{{", "}}}", :CODE) # {{{sentence-sized code}}}, for a word, use +code+
      #    add_html("no", :STRIKE) # <no>foo</no>

      add_special(/\b(?>[A-Z][a-z]+[A-Z]\w+)(?![!\w])/, :WIKIWORD) # SomeWikiName
      add_special(/\[\!?wiki:(.*?)\]/, :WIKIWORD) # [wiki:ANYTHINGYOULIKE]
      add_special(/\[\!?((https?|s?ftp|nntp|mailto|file):(.*?))\]/, :LINK)
      add_special(/(https?|s?ftp|nntp|mailto|file):(\/\/|)[-a-zA-Z0-9!\"\#$%&'()=~|^\/\[@;:,.]+/, :LINK)
    end
  end

  class WikiHtml < SM::ToHtml
    attr_accessor :children
    attr_accessor :url_prefix
    attr_accessor :template

    def initialize
      super
      self.children = []
      self.url_prefix = ''
      self.template = nil
      #    add_tag(:CODE, "<code>", "</code>")
    end
    
    def handle_special_WIKIWORD(special)
      if /\[\!?wiki:(.*?)( (.*?))?\]/ === special.text then
        wikiname = $1
        text = $2 ? $3 : $1
      else
        wikiname = special.text
        text = special.text 
      end
      
      href = wikiname + ".html"
      self.children << wikiname
      "<a href=\"#{self.url_prefix}#{href}\">#{text}</a>"
    end
    
    def handle_special_LINK(special)
      if /\[\!?(https?|s?ftp|nntp|mailto|file):([^ ]+)( (.*?))?\]/ ===
          special.text then
        href = $1 + ":" + $2
        text = $3 ? $4 : href
      else
        href = text = special.text
      end
      "<a href=\"#{href}\">#{text}</a>"
    end
    
    def htmlize(m, source)
      self.children.clear
      body_html = pretty(m.convert(source, self))
      self.children.sort!.uniq!
      body_html
    end

    def pretty(html)
      html.gsub!(/(\b[A-Z][a-z]+[A-Z]\w+)!/, '\1')
      html.gsub!(/\r?\n(<\/[a-z]*>)/m, '\1').gsub!(/(<[a-z]*>)\r?\n/, '\1')
      html.gsub!(/<li>(.*)\r?\n<\/li>/, '<li>\1</li>')
      html.split(/\r?\n/).delete_if{|i| i.strip == "" }.join("\n")
    end
  end
end
