class StreamTogether::Session
  enum ReplyCommand
    Acknowledge
    Load
    Pause
    Play
    GiveUp
    Ready

    def to_s
      case self
      when Acknowledge
        "acknowledge"
      when Load
        "load"
      when Pause
        "pause"
      when Play
        "play"
      when GiveUp
        "give up"
      when Ready
        "ready"
      else
        raise UnknownReplyCommandError.new self
      end
    end

    def self.from_s(string)
      case string
      when .starts_with? "ack"
        Acknowledge
      when "load"
        Load
      when "pause"
        ReplyCommand::Pause
      when "play"
        ReplyCommand::Play
      when "give up"
        ReplyCommand::GiveUp
      when "ready"
        ReplyCommand::Ready
      else
        raise UnknownReplyCommandError.new string
      end
    end

    def to_json(builder)
      builder.string(self.to_s)
    end

    def self.to_json(value, builder)
      builder.string(value.to_s)
    end

    def self.from_json(pull)
      from_s(pull.read_string)
    end
  end
end
