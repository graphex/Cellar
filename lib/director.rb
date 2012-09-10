require 'celluloid'
class Director
  include Celluloid

  def initialize
    @command_list = %w(exit say)
    @input = STDIN
  end

  def say_pool(lines_arr, pool_size=10)
    work_time = 0

    #make a pool
    pool = SayActor.pool(:size => pool_size)

    #line up futures
    futures = lines_arr.map do |line|
      pool.future.say(line)
    end

    #call value on futures or they may not get a chance to run before the program exits
    real_time = Benchmark.realtime do
      work_time = futures.sum do |f|
        f.value
      end
    end

    #terminate the pool so we don't have a leak
    pool.terminate

    puts "Said in #{real_time} sec, worker time was #{work_time} sec"
    puts_env_info
  end

  def puts_env_info
    puts "Actor Count: #{Celluloid::Actor.all.to_set.length} Alive: #{Celluloid::Actor.all.compact.to_set.select(&:alive?).length}"
    puts "Actors:#{Celluloid::Actor.all.compact.to_set.select(&:alive?).collect(&:class)}"
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
