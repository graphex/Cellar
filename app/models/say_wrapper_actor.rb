require 'celluloid'
require 'open4'
class SayWrapperActor
  include Celluloid
  VOICES = %w(Agnes Albert Alex Bad\ News Bahh Bells Boing Bruce Bubbles Cellos Deranged Fred Good\ News Hysterical Junior Kathy Pipe\ Organ Princess Ralph Trinoids Vicki Victoria Whisper Zarvox)

  def initialize(voice=nil)
    @voice = voice.blank? ? VOICES.shuffle[0] : voice
    @pid, @stdin, @stdout, @stderr = Open4::popen4 "sh"
    @stdin.sync = true
    #@stdin.puts "say --voice #{@voice} --progress"
    @stdin.puts "say --voice #{@voice} hello"
  end

  def say(text)
    Benchmark.realtime do
      @stdin.puts("say --voice #{@voice} #{text}")
    end
  end
end