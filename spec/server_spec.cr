require "./spec_helper"
require "spec-kemal"
require "myhtml"

describe StreamTogether::Server do
  srv = StreamTogether::Server.new ip: "172.0.0.0", port: 65500
  it "renders /" do
    get "/"
    response.status_code.should eq 200
  end
  it "renders /vid with the specified URL" do
    IO.pipe do |reader, writer|
      spawn do
        HTTP::FormData.build writer do |form|
          form.field "link", EXAMPLE_URL
        end
      end
      get "/vid", body: reader
      response.status_code.should eq 200
      html = Myhtml::Parser.new page: response.body
      html.nodes(:video).first.attribute_by("src").should eq EXAMPLE_URL
    end
  end

  describe ".command" do
    it "is in the #not_yet_joined until Ready" do
      test_data = TestWebsocket.new_session srv.dup     
      test_data.test_sock.should be_in test_data.not_yet_joined
    end
  end
end


struct TestWebsocket
  property socket_data
  property request_data
  property test_sock
  property request
  property response
  property context
  property server : StreamTogether::Server
  def initialize(server = nil)
    @socket_data = IO::Memory.new
    @request_data = IO::Memory.new
    @test_sock = HTTP::WebSocket.new io: socket_data
    @request = HTTP::Request.new "GET", request_data
    @response = HTTP::Server::Response.new request
    @context = HTTP::Server::Context.new request, response
    @server = server || StreamTogether::Server.new
  end
  def self.new_session(server = nil)
	new server
	server.command socket: test_sock, context: context
    self
  end
end
