require "./session/*"

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
      @playing = true
      self
    end

    # request
    def play(time)
      raise "playing when not ready" unless ready?
      socket.send ReplyMessage.play(source, at: time)
      @playing = true
      self
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

    getter pause_time : Time::Span?

    # buffering has timed out for at least one client, the server is giving up.
    def give_up!
      socket.send ReplyMessage.give_up! source
      self
    end

    def pause(at : Time::Span)
      raise "pausing when not playing" unless playing?
      @ready = @playing = false
      socket.send ReplyMessage.pause(source, at: (@pause_time = at))
      self
    end

    def acknowledge
      socket.send ReplyMessage.acknowledge source
      self
    end

    def load(at : Time::Span? = nil)
      socket.send ReplyMessage.load source, at: at
      self
    end
  end
end
