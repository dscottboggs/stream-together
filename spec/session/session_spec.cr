require "../spec_helper"

EXAMPLE_URL = "https://example.com/e/g/video.mp4"

# WS_PREFIX = "\x81@"

def session_command_result_for(session_method)
  %[{"command":"#{session_method}","source":"#{EXAMPLE_URL}"}]
end

def session_subject
  test_socket_io = IO::Memory.new
  {test_socket_io, StreamTogether::Session.new(HTTP::WebSocket.new(io: test_socket_io), EXAMPLE_URL)}
end

describe StreamTogether::Session do
  describe "#is_ready" do
    it "recieves the expected string" do
      test_socket_io, subject = session_subject
      subject.ready?.should eq false
      subject.is_ready.ready?.should eq true
      received = test_socket_io.rewind.gets
      received.includes! session_command_result_for "ready"
    end
  end

  describe "#play" do
    context "without a time" do
      it "receives the expected string" do
        test_socket_io, subject = session_subject
        subject.playing?.should eq false
        subject.is_ready.play.playing?.should eq true
        received = test_socket_io.rewind.gets
        received.includes! session_command_result_for "ready"
        received.includes! session_command_result_for "play"
      end
      it "raises an exception if not ready" do
        expect_raises Exception do
          _, subject = session_subject
          subject.play
        end
      end
    end
    context "with a time" do
      it "receives the expected string" do
        test_socket_io, subject = session_subject
        subject.playing?.should eq false
        subject.is_ready.play(3.minutes).playing?.should eq true
        received = test_socket_io.rewind.gets
        received.includes! session_command_result_for "ready"
        received.includes! %[{"command":"play","source":"#{EXAMPLE_URL}","timestamp":180.0}]
      end
      it "raises an exception if not ready" do
        expect_raises Exception do
          _, subject = session_subject
          subject.play(3.minutes)
        end
      end
    end
  end

  describe "#pause" do
    it "receives the expected string" do
      test_socket_io, subject = session_subject
      subject.pause_time.should be_nil
      subject.ready?.should be_false
      subject.playing?.should be_false
      subject.is_ready.play.pause at: 5.minutes
      received = test_socket_io.rewind.gets
      received.includes! session_command_result_for "ready"
      received.includes! session_command_result_for "play"
      received.includes! %[{"command":"pause","source":"#{EXAMPLE_URL}","timestamp":300.0}]
    end
    it "raises an exception if not ready" do
      expect_raises Exception, message: "pausing when not playing" do
        _, subject = session_subject
        subject.pause at: 5.minutes
      end
    end
    it "raises an exception if not playing" do
      expect_raises Exception, message: "pausing when not playing" do
        _, subject = session_subject
        subject.is_ready.pause at: 5.minutes
      end
    end
  end

  describe "#acknowledge" do
    it "receives the expected string" do
      test_socket_io, subject = session_subject
      subject.acknowledge
      test_socket_io.rewind.gets.includes! session_command_result_for "acknowledge"
    end
  end

  describe "#load" do
    context "without a time" do
      it "receives the expected string" do
        test_socket_io, subject = session_subject
        subject.load
        test_socket_io.rewind.gets.includes! session_command_result_for "load"
      end
    end
    context "with a time" do
      it "receives the expected string" do
        test_socket_io, subject = session_subject
        subject.load at: (4.minutes + 9.seconds)
        expected_result = %[{"command":"load","source":"#{EXAMPLE_URL}","timestamp":249.0}]
        test_socket_io.rewind.gets.includes! expected_result
      end
    end
  end
end
