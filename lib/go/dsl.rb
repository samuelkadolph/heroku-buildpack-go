module Go
  class DSL
    attr_reader :application

    def initialize(application)
      @application = application
    end

    def evaluate(gofile)
      instance_eval(File.read(gofile), gofile, 1)
    end

    def package(name)
      application.package = name
    end

    def method_missing(method, *args)
      method.to_s
    end
  end
end
