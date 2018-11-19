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
        @_command ||= case @command.downcase
        when "load"
          ReplyCommands::Load
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
    end
  end
end
