require "../spec_helper"

describe StreamTogether::Server::Message do
  describe ".from_json" do
    it "works" do
      subject = StreamTogether::Server::Message.new JSON::PullParser.new <<-JSON
  { "source": "https://example.com/path/to/video.mp4",
    "command": "play",
    "timestamp": 353 }
JSON
      subject.source.should eq "https://example.com/path/to/video.mp4"
      subject.command.should eq StreamTogether::Server::Commands::Play
      subject.timestamp.should eq 353.seconds
    end
  end
end
