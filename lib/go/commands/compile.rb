module Go
  module Commands
    require "go/commands/base"

    class Compile < Base
      def run
        if errors { @app.compile }
          exit 0
        else
          exit 1
        end
      end
    end
  end
end
