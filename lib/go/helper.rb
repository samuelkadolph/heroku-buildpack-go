require "go"

module Go
  module Helper
    class SystemError < StandardError
      attr_accessor :status, :executable, :arguments

      def initialize(status, executable, arguments)
        self.status, self.executable, self.arguments = status, executable, arguments
      end
    end

    def action(message)
      print "-----> #{message}... "
      yield
      puts "done"
    rescue
      puts "failed"
      raise
    end
    module_function :action

    def errors
      yield
    rescue SystemError => e
      puts " !"
      puts " !     command failed: #{e.executable} #{e.arguments.join(" ")}"
      puts e.status.output.gsub(/^/, " !     ")
      puts " !"
      exit 1
    rescue => e
      puts " !"
      puts " !     #{e.class}: #{e}"
      puts e.backtrace.join("\n").gsub(/^/, " !       from ")
      puts " !"
      exit 1
    end
    module_function :errors

    def indent
      yield
    end
    module_function :indent

    def indent!
    end
    module_function :indent!

    def system(executable, *arguments)
      output, output_ = IO.pipe
      pid = Process.spawn(executable, *arguments, :in => :close, :out => output_, :err => output_)
      output_.close
      pid, status = Process.wait2(pid)
      status.singleton_class.send(:define_method, :output) { @output ||= output.read }
      status
    end
    module_function :system

    def system!(executable, *arguments)
      arguments.flatten!
      status = system(executable, *arguments)
      status.success? or raise SystemError.new(status, executable, arguments)
    end
    module_function :system!
  end
end
