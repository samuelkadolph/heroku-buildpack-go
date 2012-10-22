module Go
  module Tools
    require "go/tools/base"

    class Bazaar < Base
      def run(*)
        raise "bzr is not yet supported"
      end
    end
  end
end
