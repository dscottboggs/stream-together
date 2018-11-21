require "../spec_helper"

Stringified = ["acknowledge", "load", "pause", "play", "give_up"]

describe StreamTogether::Server::ReplyCommands do
  describe "#to_s" do
    StreamTogether::Server::ReplyCommands::Acknowledge.to_s.should eq "acknowledge"
    StreamTogether::Server::ReplyCommands::Load.to_s.should eq "load"
    StreamTogether::Server::ReplyCommands::Pause.to_s.should eq "pause"
    StreamTogether::Server::ReplyCommands::Play.to_s.should eq "play"
    StreamTogether::Server::ReplyCommands::GiveUp.to_s.should eq "give_up"
  end
  describe ".from_s" do
    StreamTogether::Server::ReplyCommands
      .from_s("acknowledge")
      .should eq StreamTogether::Server::ReplyCommands::Acknowledge
    StreamTogether::Server::ReplyCommands
      .from_s("load")
      .should eq StreamTogether::Server::ReplyCommands::Load
    StreamTogether::Server::ReplyCommands
      .from_s("pause")
      .should eq StreamTogether::Server::ReplyCommands::Pause
    StreamTogether::Server::ReplyCommands
      .from_s("play")
      .should eq StreamTogether::Server::ReplyCommands::Play
    StreamTogether::Server::ReplyCommands
      .from_s("give_up")
      .should eq StreamTogether::Server::ReplyCommands::GiveUp
  end
  describe ".to_json" do
    Array(String).from_json(
      JSON.build do |builder|
        builder.array do
          StreamTogether::Server::ReplyCommands::Acknowledge.to_json(builder)
          StreamTogether::Server::ReplyCommands::Load.to_json(builder)
          StreamTogether::Server::ReplyCommands::Pause.to_json(builder)
          StreamTogether::Server::ReplyCommands::Play.to_json(builder)
          StreamTogether::Server::ReplyCommands::GiveUp.to_json(builder)
        end
      end.to_json
    ).should eq Stringified
  end
  describe ".from_json" do
    pull = JSON::PullParser.new Stringified.to_json
    pull.read_array do
      StreamTogether::Server::ReplyCommands.from_json(pull) while pull.kind != EOF
    end
  end
end
