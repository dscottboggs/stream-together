CMD_TO_STRING = {Join: "join", Ready: "ready", Play: "play", Pause: "pause"}

describe StreamTogether::Server::Commands do
  {% for cmd, string in CMD_TO_STRING %}
    describe "{{cmd.id}}" do
      describe "#to_s" do
        StreamTogether::Server::Commands::{{cmd.id}}.to_s.should eq {{string}}
      end
      describe ".from_s" do
        StreamTogether::Server::Commands.from_s({{string}}).should eq StreamTogether::Server::Commands::{{cmd.id}}
      end
      describe "#to_json" do
        JSON.build do |builder|
          StreamTogether::Server::Commands::{{cmd.id}}.to_json(builder)
        end.should eq %<"{{string.id}}">
      end
      describe ".to_json" do
        JSON.build do |builder|
          StreamTogether::Server::Commands.to_json(
            StreamTogether::Server::Commands::{{cmd.id}},
            builder
          )
        end.should eq %<"{{string.id}}">
      end
      describe ".from_json" do
        StreamTogether::Server::Commands.from_json(
          JSON::PullParser.new %<"{{string.id}}">
        ).should eq StreamTogether::Server::Commands::{{cmd.id}}
      end
    end
  {% end %}
end
