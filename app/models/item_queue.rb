require 'sidekiq'

class ItemQueue

  include Sidekiq::Worker

  def perform(item)
    case (item.to_sym)
      when :simple_say
        Sidekiq.logger.info SayActor.new.say("Hello World")
    end
  end
end