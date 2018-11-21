module StreamTogether
  class Server
    struct ReplyMessage < Message
      include JSON::Serializable
      private property command : String
      private property source : String
      private property timestamp : Time::Span?
      def initialize(@command, @source, @timestamp = nil)
      end

      def command : Command
        @_command ||= ReplyCommands.from_s @command
      end

      def command=(cmd : ReplyCommands)
        @_command = cmd
        @command = cmd.to_s
        self
      end

      def self.give_up!(source)
        new("give up", source).to_json
      end
      def self.load(source)
        new("load", source).to_json
      end
      def self.play(source, at = nil)
        new("play", source, at).to_json
      end
      def self.pause(source, at : Time::Span)
        new("pause", source, at).to_json
      end
      def self.acknowledge(source)
        new("ack", source).to_json
      end
    end
  end
end
