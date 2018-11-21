module StreamTogether
  class Session
    def initialize(@socket, @source); end

    property socket : HTTP::WebSocket
    property source : String

    # ready? indicates whether the client has loaded the video yet
    @ready = false
    def ready?
      @ready
    end
    # indicate that a given session is ready.
    def is_ready
      socket.send ReplyMessage.ready source
      @ready = true
      self
    end

    # indicate that a given client is trying to (and possibly currently
    # succeeding at) playing the video.
    @playing = false
    def play
      raise "playing when not ready" unless ready?
      socket.send ReplyMessage.play source
    end
    # request
    def play(time)
      raise "playing when not ready" unless ready?
      socket.send ReplyMessage.play(source, at: time)
    end
    def play_at(time)
      play(time)
    end
    # The client is currently trying to play the video
    def playing?
      @playing
    end
    # I.E. the play message has been received but NOT the *ready* message.
    def loading?
      ready? && !playing?
    end
    @pause_time = Time::Span?
    def pause_at(time)
      @pause_time = time
    end

    # buffering has timed out for at least one client, the server is giving up.
    def give_up!
      socket.send ReplyMessage.give_up! source
    end

    def pause(at : Time::Span? = nil)
      socket.send ReplyMessage.pause(source, timestamp: at)
    end

    def acknowledge
      socket.send ReplyMessage.acknowledge source
    end

    def load(at : Time::Span? = nil)
      socket.send ReplyMessage.load source, timestamp: at
    end
  end
end
