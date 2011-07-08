require File.expand_path(File.dirname(__FILE__) + "/../spec_helper.rb")

describe Squirrel::Server do
  context "#start" do
    before(:each) do
      @config = mock().as_null_object
      Squirrel::Configuration.stub(:new).and_return(@config)
    end

    it "starts the Event Machine loop" do
      EM.should_receive(:run)
      subject.start
    end

    it "reads the configuration YAML" do
      em do
        YAML.should_receive(:load_file).with(Squirrel::Server.root + '/config/squirrel.yml').and_return(input: 'websocket')
        subject.start
      end
    end

    context "when input is configured" do
      it "initialize a input connection" do
        YAML.should_receive(:load_file).and_return(input: 'websocket')
        em do
          @config.should_receive(:input)
          subject.start
        end
      end
    end

    context "when output is configured" do
      it "initilizes a output connection" do
        YAML.should_receive(:load_file).and_return(output: 'websocket')
        em do
          @config.should_receive(:output)
          subject.start
        end
      end
    end

    context "when game_engine is configured" do
      it "initilizes a game_engine connection" do
        YAML.should_receive(:load_file).and_return(game_engine: 'websocket')
        em do
          @config.should_receive(:game_engine)
          subject.start
        end
      end
    end
  end
end