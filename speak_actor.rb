require 'celluloid'
class SpeakActor
  include Celluloid
  VOICES = %w(Agnes Albert Alex Bad\ News Bahh Bells Boing Bruce Bubbles Cellos Deranged Fred Good\ News Hysterical Junior Kathy Pipe\ Organ Princess Ralph Trinoids Vicki Victoria Whisper Zarvox)

  def initialize
    @voice = VOICES.shuffle[0]
  end

  def do_stuff
    my_pool = TestActor.pool(:size => 10)
    my_futures = 10.times.map do |i|
      my_pool.future(:do_a_thing, i)
    end
    @answer = 0
    my_futures.each do |f|
      v = f.value
      @answer += v
    end
    links = my_pool.links
    my_pool.terminate
    links.map &:terminate
    say_the_answer
    puts "Actor Count: #{Celluloid::Actor.all.to_set.length} Alive: #{Celluloid::Actor.all.to_set.reject{|a| !a.alive?}.length}"
    #puts "Actors:#{Celluloid::Actor.all.to_set.select(&:alive?).collect(&:class)}"
    self.terminate
  end

  def speak(lines)
    puts "#{lines}"
    `speak #{lines}`
  end

  def do_a_thing(num)
    voice = voices.sample
    `say --voice #{voice} I am number #{num}`
    return num
  end
end