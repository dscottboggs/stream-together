require "../spec_helper"

Stringified = {Acknowledge: "acknowledge",
               Load:        "load",
               Pause:       "pause",
               Play:        "play",
               GiveUp:      "give up"}

describe StreamTogether::Session::ReplyCommand do
  describe "#to_s" do
    it "outputs the correct string" do
      StreamTogether::Session::ReplyCommand::Acknowledge.to_s.should eq "acknowledge"
      StreamTogether::Session::ReplyCommand::Load.to_s.should eq "load"
      StreamTogether::Session::ReplyCommand::Pause.to_s.should eq "pause"
      StreamTogether::Session::ReplyCommand::Play.to_s.should eq "play"
      StreamTogether::Session::ReplyCommand::GiveUp.to_s.should eq "give up"
    end
  end
  describe ".from_s" do
    {% for cmd_val, string in Stringified %}
    context "StreamTogether::Session::ReplyCommand::{{ cmd_val.id }}" do
      it "gets the correct value from a string" do
        StreamTogether::Session::ReplyCommand
          .from_s({{string}})
          .should eq StreamTogether::Session::ReplyCommand::{{ cmd_val.id }}
        end
    end
    {% end %}
    it "raises an UnknownReplyCommandError when it receives an unrecognized string" do
      expect_raises StreamTogether::UnknownReplyCommandError do
        StreamTogether::Session::ReplyCommand.from_s "nonsense"
      end
    end
  end
  describe ".to_json" do
    {% for cmd_val, string in Stringified %}
      context "StreamTogether::Session::ReplyCommand::{{ cmd_val.id }}" do
        it "will build the correct JSON text." do
          JSON.build do |builder|
            StreamTogether::Session::ReplyCommand::{{ cmd_val.id }}.to_json(builder)
          end.should eq "\"{{ string.id }}\""
        end
      end
    {% end %}
  end
  describe ".from_json" do
    {% for cmd_val, string in Stringified %}
    context "StreamTogether::Session::ReplyCommand::{{ cmd_val.id }}" do
      it "parses the json text without raising an UnknownReplyCommandError" do
        StreamTogether::Session::ReplyCommand.from_json(
          JSON::PullParser.new(
            %<{{ string }}>
          )
        ).should eq StreamTogether::Session::ReplyCommand::{{ cmd_val.id }}
      end
    end
    {% end %}
    it "raises an UnknownReplyCommandError on receiving an arbitrary string" do
      expect_raises StreamTogether::UnknownReplyCommandError do
        JSON.build do |builder|
          StreamTogether::Session::ReplyCommand.from_json(
            JSON::PullParser.new(
              %<"an arbitrary string">
            )
          )
        end
      end
    end
  end
end
