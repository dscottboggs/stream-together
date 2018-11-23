class StreamTogether::Server
  enum Commands
    Join
    Ready
    Play
    Pause

    def to_s
      case self
      when Join ; "join"
      when Ready; "ready"
      when Play ; "play"
      when Pause; "pause"
      end
    end

    def self.from_s(string)
      case string
      when "join" ; Join
      when "ready"; Ready
      when "play" ; Play
      when "pause"; Pause
      else          raise UnknownCommandError.new string
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
