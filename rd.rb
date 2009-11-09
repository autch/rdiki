#!/usr/bin/ruby

require 'rdiki'
require 'optparse'

c = RDiki::Compiler.new
opt = OptionParser.new("RDiki: Offline single-user wiki-modoki using RDoc\n" +
                       "Usage: #{$0} [options]")
opt.on('-r PATH', '--rd-path PATH', String,
       "path where to find .rd files"){|path| c.rd_prefix(path) }
opt.on('-h PATH', '--html-path PATH', String,
       "path where html files are generated"){|path| c.html_prefix(path) }
opt.on('-p PREFIX', '--url-prefix PREFIX', String,
       "<a href=\"PREFIX/WikiName.html\">"){|prefix| c.url_prefix(prefix) }
opt.on('-t FILENAME', '--template FILENAME', String,
       "use ERB template FILENAME"){|tpl| c.template(tpl) }

names = opt.parse(ARGV)

names.push("FrontPage") if names.empty?
c.enqueue(names)
c.start
