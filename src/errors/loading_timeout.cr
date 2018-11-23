module StreamTogether
  class LoadingTimeout < Exception
    def initialize(source, sessions)
      super "
        the following sessions, associated with #{source}, failed to load.#{sessions[source].select &.ready?}"
    end
  end
end
