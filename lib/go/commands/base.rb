module Go
  require "go/application"
  require "go/helper"

  module Commands
    class Base
      include Helper

      def initialize(options = {})
        @app = Application.new(options)
      end

      def run
        raise NotImplementedError
      end
    end
  end
end
