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

module StreamTogether
  class Server
    PWD = "/home/scott/Documents/code/stream_together"
    def initialize(@ip="0.0.0.0", @port=80, @public_folder = nil)
      Kemal.config.host_binding = @ip
      Kemal.config.port = @port
      Kemal.config.public_folder = @public_folder unless @public_folder.nil?
    end
    def self.serve_up(ip="0.0.0.0", port=80)
      new(ip, port).serve_up
    end
    def serve_up
      Kemal.run do
        ws "/" { |env| command env }
        get "/vid" { |env| render_video_page env }
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
    def render_video_page(env)

    end

    # open a command/control environment with the client player
    def command(env)
      # TODO: implement
      raise "not yet implemented"
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
