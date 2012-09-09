require 'celluloid'
class Director
  include Celluloid

  def initialize
    @command_list = %w(exit say)
    @input = STDIN
  end

  def get_command
    inputline = @input.gets
    inputline.chomp!
    tokens = inputline.split(' ')
    command = tokens.shift
    if @command_list.index(command) != nil then
      self.send(command, tokens.join(' '))
    end
  end

  def start_input_loop
    while @command != "exit"
      get_command
      puts @command
    end
  end

  def say(string)
    puts string
    `say #{string}`
  end
end

Director.new.start_input_loop