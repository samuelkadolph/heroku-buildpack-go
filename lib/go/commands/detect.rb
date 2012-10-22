module Go
  module Commands
    require "go/commands/base"

    class Detect < Base
      def run
        if name = @app.detect
          puts name
          exit 0
        else
          exit 1
        end
      end
    end
  end
end
