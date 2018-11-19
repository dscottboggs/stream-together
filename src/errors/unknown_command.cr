module StreamTogether
  class UnknownCommandError < Exception
    def initialize(command)
      super "got unknown command #{command}"
    end
  end
end
