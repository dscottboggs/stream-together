EXAMPLE_URL = "https://example.com/e/g/video.mp4"

describe StreamTogether::Session do
  test_socket_receiver = IO::Memory.new
  test_socket_proto = HTTP::WebSocket::Protocol.new(test_socket_receiver)
  test_socket = HTTP::WebSocket.new ws: test_socket_proto
  subject = StreamTogether::Session.new(test_socket, EXAMPLE_URL)

  describe "#is_ready" do
    subject.ready?.should eq false
    subject.is_ready.ready?.should eq true
    p! test_socket_receiver.gets
  end
end
