require "yaml"

module Go
  module Commands
    require "go/commands/base"

    class Release < Base
      def run
        puts @app.release.to_yaml
        exit 0
      end
    end
  end
end
