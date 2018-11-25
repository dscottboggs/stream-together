require "../spec_helper"

METHODS_TO_STRINGS = {give_up!:    "give up",
                      load:        "load",
                      play:        "play",
                      acknowledge: "acknowledge",
                      ready:       "ready"}

def cmd_from_str(str)
  {command: str, source: EXAMPLE_URL}.to_json
end

describe StreamTogether::Session::ReplyMessage do
  {% for method, string in METHODS_TO_STRINGS %}
  describe ".{{method.id}}" do
    it "responds with the correct JSON" do
      StreamTogether::Session::ReplyMessage.{{method.id}}(EXAMPLE_URL).should eq cmd_from_str {{ string }}
    end
  end
  {% end %}
  describe ".pause" do
    it "responds with the correct JSON" do
      StreamTogether::Session::ReplyMessage.pause(
        EXAMPLE_URL,
        10.seconds).should eq({
        command: "pause", source: EXAMPLE_URL, timestamp: 10.0,
      }.to_json)
    end
  end
end
