require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper.rb")

describe Squirrel::GameEngine::Socket do
  describe "when a new connection is established" do
    it "adds the current socket to the socket list" do
      lambda do
        subject.new_connection(stub.as_null_object)
      end.should change(Squirrel::GameEngine.connections, 'size').by(1)
    end
  end

  describe "when the connection is closed" do
    it "removes the socket from the socket list" do
      ws = subject.new_connection(stub.as_null_object)
      lambda do
        subject.destroy_connection(ws)
      end.should change(Squirrel::GameEngine.connections, 'size').by(-1)
    end

    it "returns an ack" do
      ws = mock
      ws.should_receive(:send).with('ack')
      subject.destroy_connection(ws)
    end
  end
end