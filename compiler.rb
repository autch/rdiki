
require 'markup.rb'

module RDiki
  class Compiler
    def initialize
      @processed_names = []
      @negative_list = []
      @queue = []
      @prefixes = { :rd => '.', :html => '.', :url => '' }
      @template = nil
      
      @markup = Markup.new
      @html = WikiHtml.new
      @erb = RDiki::ErbTemplate.new
    end

    def enqueue(names)
      names.each{|n| @queue << n }
    end

    def rd_prefix(prefix)
      @prefixes[:rd] = prefix
    end

    def html_prefix(prefix)
      @prefixes[:html] = prefix
    end

    def url_prefix(prefix)
      @prefixes[:url] = prefix
      @html.url_prefix = prefix
    end

    def template(filename)
      @template = filename
    end

    def w2rd(wikiname)
      File.join(@prefixes[:rd], "#{wikiname}.rd")
    end
    
    def w2html(wikiname)
      File.join(@prefixes[:html], "#{wikiname}.html")
    end
    
    def compile(wikiname)
      begin
        filename = w2rd(wikiname)
        $stderr.print wikiname + ": "
        begin
          source = File.open(filename, "rb"){|f| f.read }
          html = @html.htmlize(@markup, source)
          if @template then
            html = @erb.apply(@template, html, { :name => wikiname.dup })
          else
            html = "<html><head></head><body>#{html}</body></html>"
          end
          File.open(w2html(wikiname), "wb"){|f| f.print html }
          $stderr.print @html.children.join(", ")
        rescue Errno::ENOENT
          $stderr.printf("%s: not found", filename)
          @negative_list << wikiname
          return
        end
        @processed_names << wikiname
        removal = @processed_names + @negative_list
        removal.sort!.uniq!
        (@html.children - removal).each{|cname|
          @queue << cname
        }
      ensure
        $stderr.print "\n"
      end
    end
    
    # RD + erb -> html
    def compile_snippet(filename, &block)
      begin
        source = File.open(filename, "rb"){|f| f.read }
        html = @html.htmlize(@markup, source)
        html = @erb.eval(html, &block)
       rescue Errno::ENOENT
        $stderr.printf("\n%s: snippet not found\n", filename)
        return
      end
    end

    def start
      until @queue.empty? do
        compile(@queue.pop)
      end
      $stderr.puts
      $stderr.printf("Failed pages: %s\n",
                     @negative_list.join(", ")) unless @negative_list.empty?
    end
  end
end
