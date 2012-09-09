require 'celluloid'
class SayActor
  include Celluloid
  VOICES = %w(Agnes Albert Alex Bad\ News Bahh Bells Boing Bruce Bubbles Cellos Deranged Fred Good\ News Hysterical Junior Kathy Pipe\ Organ Princess Ralph Trinoids Vicki Victoria Whisper Zarvox)

  def initialize(voice)
    @voice = voice.blank? ? VOICES.shuffle[0] : voice
  end

  def say(text)
    Benchmark.realtime do
      `say --voice #{@voice} #{text}`
    end
  end
end