require "fileutils"
require "go"
require "open-uri"

module Go
  require "go/helper"

  module Tools
    class Base
      include Helper

      class << self
        attr_reader :bin, :executable, :name, :packages, :version

        def path
          File.join("tools", "#{name}-#{version}")
        end

        private
          attr_writer :bin, :executable, :name, :packages, :version
          def deb(url)
            packages || self.packages = []
            packages << url
            url
          end
      end

      self.bin = "bin"
      self.packages = []

      def initialize(cache)
        raise ArgumentError, "cache cannot be nil" unless cache
        @cache = cache
      end

      def run(*args)
        install unless installed?
        exec(File.join(@cache, self.class.path, self.class.bin, self.class.executable), *args)
      end

      def install
        action "Fetching #{self.class.name} #{self.class.version}" do
          chdir do
            self.class.packages.each do |package|
              deb = download(package)
              extract(deb)
            end
          end
        end
      end

      def installed?
        chdir { File.directory?(self.class.path) }
      end

      private
        def chdir(&block)
          Dir.chdir(@cache, &block)
        end

        def download(url)
          filename = File.basename(url)
          File.open(filename, "wb") do |file|
            result = open(url)
            raise "Could not download #{url}" unless result.status[0] == "200"
            file << result.read
          end
          filename
        end

        def extract(deb, destination = self.class.path)
          FileUtils.mkdir_p(destination)
          system!("dpkg-deb", "--extract", deb, destination)
          File.delete(deb)
        end
    end
  end
end
