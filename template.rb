
require 'erb'

module RDiki
  class ErbTemplate
    class DefaultErbNamespace
      include ERB::Util
      attr_accessor :params

      def initialize(p)
        self.params = p
      end
    end

    def run(filename, params = { }, &block)
      erb = ERB.new(File.read(filename), nil, '-')
      erb.def_method(DefaultErbNamespace, "erb", filename)
      ns = DefaultErbNamespace.new(params)
      ns.erb &block
    end

    def apply(filename, source, params = { })
      self.run(filename, params){ source }
    end

    def eval(source, &block)
      erb = ERB.new(source, nil, '-')
      erb.def_method(DefaultErbNamespace, "erb")
      ns = DefaultErbNamespace.new
      ns.erb &block
    end
  end

  class RdTemplate
    def run(filename)
    end
  end
end

