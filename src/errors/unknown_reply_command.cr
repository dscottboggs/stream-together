module StreamTogether

class UnknownReplyCommandError < UnknownCommandError
  def initialize(command)
    super "got unknown reply command #{command}"
  end
end
end
