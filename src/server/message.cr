module StreamTogether
  class Server
    # A message received across the WebSocket connection.
    #
    # This message must be JSON-formatted, and contain at least a `command` and
    # `source` element. The `command` value must be set to one of "join",
    # "ready", "play", or "pause". So that the session surrounding a given video
    # can be referenced, one must always provide the relevant media source URL
    # with every command, not just the "join" command. For example:
    #
    # ```
    # {
    #   "source": "https://example.com/path/to/video.mp4",
    #   "command": "play",
    #   "payload": < current timestamp >
    # }
    # ```
    struct Message
      include JSON::Serializable
      # the link to the video that is being streamed.
      property source : String
      # The play and pause commands need to send their timestamps
      # to aid in resynchronizing a stream which has potentially fallen out of
      # sync.
      @[JSON::Field(converter : Time::EpochConverter)]
      property timestamp : Time::Span?
      property ready? = false

      def is_ready
        ready? = true
      end

      setter @command : String

      def command : Command
        @_command ||= case @command.downcase
                      when "join"
                        Commands::Join
                      when "ready"
                        Commands::Ready
                      when "play"
                        Commands::Play
                      when "pause"
                        Commands::Play
                      else
                        raise UnknownCommandError.new @command
                      end
      end

      def command=(cmd : Command)
        @_command = cmd
      end
    end
  end
end
