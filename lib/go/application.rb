require "digest/sha1"

module Go
  require "go/dsl"
  require "go/helper"

  class Application
    include Helper

    class << self
      attr_reader :goversion

      def goarchive
        "http://go.googlecode.com/files/go#{goversion}.linux-amd64.tar.gz"
      end

      def gorelease
        "go-#{goversion}"
      end

      private
        attr_writer :goversion
    end

    self.goversion = "1.0.3"

    attr_accessor :build, :cache, :package
    attr_reader :id

    def initialize(options = {})
      self.build, self.cache = options.values_at(:build, :cache)
      @id = Digest::SHA1.hexdigest("#{Time.now.to_f}-#{rand(1_000_000)}")[0..7]
      raise ArgumentError, "build path must be specified" unless build
    end

    def compile
      eval_gofile!
      set_environment_variables
      fetch_go
      build_app
      true
    end

    def detect
      in_build { File.exists?("Gofile") } && "Go"
    end

    def release
      eval_gofile!
      values = {}
      values["addons"] = {}
      values["config_vars"] = { "PATH" => "/app/bin:/usr/local/bin:/usr/bin:/bin" }
      values["default_process_types"] = { "app" => "#{File.basename(package)}" }
      values
    end

    protected
    def set_environment_variables
      ENV["CACHE"] = cache
      ENV["GOROOT"] = goroot
      ENV["GOPATH"] = gopath
      ENV["PATH"] = "#{buildpack}/bin:#{goroot}/bin:#{ENV["PATH"]}"
      ENV.delete("GIT_DIR")
    end

    def fetch_go
      return if File.directory?(goroot)

      action "Fetching Go #{self.class.goversion}" do
        system! "rm", "-rf", "#{cache}/go"
        system! "mkdir", "-p", "#{cache}/go"
        Dir.chdir("#{cache}/go") do
          system! "curl", "-s", "-o", "go.tar.gz", self.class.goarchive
          system! "tar", "-zxf", "go.tar.gz"
          system! "mv", "go", self.class.gorelease
          system! "rm", "-rf", "go.tar.gz"
        end
      end
    end

    def build_app
      action "Building Go app" do
        system! "mkdir", "-p", packagepath
        system! "cp", "-r", Dir[File.join(build, "{.git,*}")], packagepath
        Dir.chdir(packagepath) do
          system! "go", "get", "./..."
        end
        system! "mkdir", "-p", binpath
        system! "cp", Dir[File.join(gopath, "bin", "*")], binpath
      end
    end

    private
    def binpath
      File.join(build, "bin")
    end

    def buildpack
      File.expand_path("../../..", __FILE__)
    end

    def eval_gofile
      return nil unless detect
      in_build { DSL.new(self).evaluate("Gofile") }
      raise "You must specify a package name in your Gofile" unless package
      true
    end

    def eval_gofile!
      eval_gofile or raise "No Gofile found was found"
    end

    def gopath
      File.join(build, ".go-#{id}")
    end

    def goroot
      File.join(cache, "go", self.class.gorelease)
    end

    def in_build(&block)
      Dir.chdir(build, &block)
    end

    def in_cache(&block)
      Dir.chdir(cache, &block)
    end

    def in_gopath(&block)
      Dir.chdir(gopath, &block)
    end

    def packagepath
      File.join(gopath, "src", package)
    end
  end
end
