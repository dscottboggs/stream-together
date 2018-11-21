enum StreamTogether::Server::ReplyCommands
  Acknowledge
  Load
  Pause
  Play
  GiveUp
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
      "give_up"
    end
  end

  def self.from_s(string)
    case self
    when .starts_with? "ack"
      Acknowledge
    when "load"
      Load
    when "pause"
      ReplyCommands::Pause
    when "play"
      ReplyCommands::Play
    when "give up"
      ReplyCommands::GiveUp
    else
      raise UnknownReplyCommandError.new @command
    end
  end

  def to_s(builder)
    builder.string(self.to_s)
  end
  def self.to_json(value, builder)
    builder.string(value.to_s)
  end
  def self.from_json(pull)
    from_s(pull.read_string)
  end
end
