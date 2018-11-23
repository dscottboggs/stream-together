# Stream Together: (roughly) synchronize watching the same streamed media
# between multiple parties
# Copyright (C) 2018 D. Scott Boggs
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of version 3 of the GNU Affero General Public License as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "kemal"
require "./server/*"

module StreamTogether
  class Server
    PWD            = "/home/scott/Documents/code/stream_together"
    TIMEOUT_PERIOD = 15.seconds
    property sessions = Hash(String, Array(Session)).new
    property not_yet_joined = [] of HTTP::WebSocket
    private property flash_messages = [] of String

    def initialize(@ip = "0.0.0.0", @port = 80, public_folder = nil)
      Kemal.config.host_binding = @ip
      Kemal.config.port = @port
      Kemal.config.public_folder = @public_folder unless @public_folder.nil?
    end

    def self.serve_up(ip = "0.0.0.0", port = 80)
      new(ip, port).serve_up
    end

    def serve_up
      Kemal.run do
        ws "/" { |sock, ctx| command sock, ctx }
        get "/vid" { |ctx| render_video_page ctx }
        get "/" { render_page "index.html" }
      end
    end

    def port=(@port)
      Kemal.config.port = @port
    end

    def ip=(@ip)
      Kemal.config.host_binding = @ip
    end

    # Receive a video URL in a Form, and render a video pulled from that URL.
    def render_video_page(context)
      _url = context.params.body["link"]?
      if (url = _url).nil?
        flash "No URL received"
        context.redirect "/"
      end
    end

    # open a command/control environment with the client player
    def command(socket, context)
      # TODO: implement
      raise "not yet implemented"
      this_session : Session? = nil
      not_yet_joined << socket
      (sockets << socket).on_message do |msg|
        case (message = Message.from_json msg).command
        when Commands::Join
          sessions[message.source] << (this_session = Session.new socket, message.source)
          not_yet_joined.delete socket
          this_session.load
        when Commands::Ready
          if (sesh = this_session).nil?
            halt context,
              status_code: 400,
              response: "must join and play before indicating ready"
          else
            sesh.is_ready
            if sessions[message.source].all? &.ready?
              sessions[message.source].each do |session|
                session.play
              end
            else
              timeout session
              session.acknowledge
            end
          end
        when Commands::Play
          if sesh = this_session
            sessions[message.source].each &.load at: message.timestamp
          else
            # this_session was nil
            halt context,
              status_code: 400,
              response: "must join before playing"
          end
        when Commands::Pause
          halt(
            context,
            status_code: 400,
            response: "must join and be ready to begin playing"
          ) if this_session.nil?
          sessions[message.source].each &.pause at: message.timestamp
        else
          raise UnknownCommandError.new message
        end
      end
    rescue err : UnknownCommandError
      raise if DEBUG
      halt context, status_code: 400, response: "Received unknown command "
    end

    # TODO display flash messages
    def flash(msg)
      flash_messages << msg
    end

    private def timeout(session)
      spawn do
        sleep TIMEOUT_PERIOD
        session.give_up! unless sessions[session.source].all? &.playing?
      end
    end

    # render a given page relative to the "views" directory.
    macro render_page(filename)
      render(
        File.join(PWD, "views", "#{filename}.ecr",
        File.join(PWD, "views", "headers.html.ecr",
        File.join(PWD, "views", "video_form.html.ecr"
      )
    end
  end
end
