require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper.rb")

describe Squirrel::Input::WebSocket do
	before(:each) do
	  Squirrel::Input.queue.instance_variable_set :@items, []
	end

	describe "when a new connection is established" do
		it "adds the current socket to the socket list" do
		  lambda do
		  	subject.new_connection(stub.as_null_object)
		  end.should change(Squirrel::Input.connections, 'size').by(1)
		end

		it "pushes a new connection message to the queue" do
			em do
			  Squirrel::Input.queue.should be_empty
				SecureRandom.should_receive(:uuid).and_return '1234'
			  subject.new_connection(stub.as_null_object)
			  Squirrel::Input.queue.should_not be_empty
			end
		end

		it "returns the uuid" do
			SecureRandom.should_receive(:uuid).and_return '1234'
		  ws = mock
		  ws.should_receive(:send).with('1234')
		  subject.new_connection(ws)
		end
	end

	describe "when a message arrives" do
		it "add the message to the queue" do
			em do
				Squirrel::Input.queue.should be_empty
				subject.new_message(stub('ws').as_null_object, 'anything')
				Squirrel::Input.queue.should_not be_empty
			end
		end

		it "returns an ack" do
			ws = mock
			ws.should_receive(:send).with('ack')
			subject.new_message(ws, 'anything')
		end
	end

	describe "when the connection is closed" do
	  it "removes the socket from the socket list" do
	  	ws = subject.new_connection(stub.as_null_object)
	    lambda do
	    	subject.destroy_connection(ws)
	    end.should change(Squirrel::Input.connections, 'size').by(-1)
	  end

		it "returns an ack" do
			ws = mock
			ws.should_receive(:send).with('ack')
			subject.destroy_connection(ws)
		end
	end
end