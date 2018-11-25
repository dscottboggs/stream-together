require "json"

class StreamTogether::Session
  struct ReplyMessage
    include JSON::Serializable
    private property command : ReplyCommand
    private property source : String
    @[JSON::Field(converter: Time::Span::SecondConverter)]
    private property timestamp : Time::Span?

    def initialize(@command, @source, @timestamp = nil)
    end

    def self.give_up!(source)
      new(ReplyCommand::GiveUp, source).to_json
    end

    def self.load(source, at = nil)
      new(ReplyCommand::Load, source, timestamp: at).to_json
    end

    def self.play(source, at = nil)
      new(ReplyCommand::Play, source, at).to_json
    end

    def self.pause(source, at : Time::Span)
      new(ReplyCommand::Pause, source, at).to_json
    end

    def self.acknowledge(source)
      new(ReplyCommand::Acknowledge, source).to_json
    end

    def self.ready(source)
      new(ReplyCommand::Ready, source).to_json
    end
  end
end
