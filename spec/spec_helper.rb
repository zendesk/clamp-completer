require "bundler/setup"
require "clamp/completer"

module CommandFactory
  def given_command(name, &block)
    let(:command_class) do
      Class.new(Clamp::Command, &block)
    end
    let(:command) do
      command_class.new(name)
    end
  end
end
module OutputCapture
  def self.included(target)
    target.before do
      $stdout = @out = StringIO.new
      $stderr = @err = StringIO.new
    end

    target.after do
      $stdout = STDOUT
      $stderr = STDERR
    end
  end

  def stdout
    @out.string
  end

  def stderr
    @err.string
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
