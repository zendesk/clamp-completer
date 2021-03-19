require 'clamp'

RSpec.describe Clamp::Completer do
  include OutputCapture
  extend CommandFactory

  it "has a version number" do
    expect(Clamp::Completer::VERSION).not_to be nil
  end

  given_command("cmd") do
    subcommand "complete", "shell autocompletions", Clamp::Completer.new(self)
    subcommand "render-profile", "Command with hyphen" do
      def execute
        puts "Command with hyphen"
      end
    end
  end

  it "generates zsh autocompletion" do
    command.run(%w[complete zsh])
    expect(stdout).to eq(%{#compdef rspec


_rspec_complete_subcommands() {
  return 1
}


_rspec_complete() {
  local curcontext="$curcontext" state state_descr line expl
  local ret=1

  _arguments -C : \\
    '1:subcommands:_rspec_complete_subcommands' \\
            {-h,--help}'[print help]' \\
    '*::options:->options' && return 0

  case "$state" in
    command) _rspec_complete_subcommands && return 0 ;;
    options)
      local command="${line[1]}"
      curcontext="${curcontext%:*:*}:rspec_complete-${command}"

      line=(${line:1})
      local completion_func="_rspec_complete_${command//-/_}"
      _call_function ret "${completion_func}" && return ret

      _message "a completion function is not defined for ${command}"
      return 1
    ;;
  esac
}


_rspec_render_profile_subcommands() {
  return 1
}


_rspec_render_profile() {
  local curcontext="$curcontext" state state_descr line expl
  local ret=1

  _arguments -C : \\
    '1:subcommands:_rspec_render_profile_subcommands' \\
            {-h,--help}'[print help]' \\
    '*::options:->options' && return 0

  case "$state" in
    command) _rspec_render_profile_subcommands && return 0 ;;
    options)
      local command="${line[1]}"
      curcontext="${curcontext%:*:*}:rspec_render_profile-${command}"

      line=(${line:1})
      local completion_func="_rspec_render_profile_${command//-/_}"
      _call_function ret "${completion_func}" && return ret

      _message "a completion function is not defined for ${command}"
      return 1
    ;;
  esac
}


_rspec_subcommands() {
  local subcommands=( 'complete:shell autocompletions' 'render-profile:Command with hyphen' )
  _describe 'subcommands' subcommands && return 0
  return 1
}


_rspec() {
  local curcontext="$curcontext" state state_descr line expl
  local ret=1

  _arguments -C : \\
    '1:subcommands:_rspec_subcommands' \\
            {-h,--help}'[print help]' \\
    '*::options:->options' && return 0

  case "$state" in
    command) _rspec_subcommands && return 0 ;;
    options)
      local command="${line[1]}"
      curcontext="${curcontext%:*:*}:rspec-${command}"

      line=(${line:1})
      local completion_func="_rspec_${command//-/_}"
      _call_function ret "${completion_func}" && return ret

      _message "a completion function is not defined for ${command}"
      return 1
    ;;
  esac
}


compdef _rspec rspec
})
  end
end
