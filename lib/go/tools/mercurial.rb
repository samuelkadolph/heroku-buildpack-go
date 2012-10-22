module Go
  module Tools
    require "go/tools/base"

    class Mercurial < Base
      def run(*)
        raise "hg is not yet supported"
      end
    end
  end
end
