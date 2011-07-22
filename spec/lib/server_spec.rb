require File.expand_path(File.dirname(__FILE__) + "/../spec_helper.rb")

describe Squirrel::Server do
  context "#start" do
    before(:each) do
      @config = mock().as_null_object
      # Squirrel::Configuration.stub(:new).and_return(@config)
    end

    it "starts the Event Machine loop" do
      EM.should_receive(:run)
      subject.start
    end

    it "reads the configuration YAML" do
      em do
        YAML.should_receive(:load_file).with(Squirrel::Server.root + '/config/squirrel.yml').and_return('input' => {'type' => 'web_socket', 'host' => '0.0.0.0', 'port' => '8080'})
        subject.start
      end
    end

    context "when input is configured to" do
      context "websocket" do
        it "it initialize a websocket connection" do
          YAML.should_receive(:load_file).and_return(yml)
          em do
            Squirrel::Input::WebSocket.should_receive(:start)
            subject.start
          end
        end
      end

      context "socket" do
        it "it initialize a socket connection" do
          YAML.should_receive(:load_file).and_return(yml('input' => {'type' => 'socket'}))
          em do
            Squirrel::Input::Socket.should_receive(:start)
            subject.start
          end
        end
      end

      context "an unsupported connection" do
        it "raises an exception" do
          YAML.should_receive(:load_file).and_return(yml('input' => {'type' => 'outro'}))
          em do
            lambda do
              subject.start
            end.should raise_exception(Squirrel::UnsupportedAdapter)
          end
        end
      end
    end

    context "when output is configured" do
      it "initilizes a output connection" do
        YAML.should_receive(:load_file).and_return(yml('output' => 'web_socket'))
        em do
          Squirrel::Output::WebSocket.should_receive(:start)
          subject.start
        end
      end
    end

    context "when game_engine is configured" do
      it "initilizes a game_engine connection" do
        YAML.should_receive(:load_file).and_return(yml('game_engine' => 'socket'))
        em do
          Squirrel::GameEngine::Socket.should_receive(:start)
          subject.start
        end
      end
    end
  end
end

def yml(options = nil)
  {
    'input' => {
      'type' => 'web_socket',
      'host' => '0.0.0.0',
      'port' => '9876'
    }
  }.merge options || {}
end