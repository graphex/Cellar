require 'celluloid'
require 'speak_actor'
require 'say_actor'

class Cellar
  include Celluloid

  def initialize
    Celluloid::Registry[:say_it] = SayActor.new
  end

  def say(line)
    Celluloid::Registry[:say_it].say(line)
  end


end