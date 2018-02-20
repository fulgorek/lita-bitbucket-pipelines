require "spec_helper"

describe Lita::Handlers::BitbucketPipelines, lita_handler: true do
  it { route_http(:post, "/bitbucket-pipelines").to(:receive) }

  describe "#receive" do
    before do
      Lita.config.robot.locale = :en
    end

    let(:request) do
      request = double("Rack::Request")
      allow(request).to receive(:params).and_return(params)
      allow(request).to receive(:body).and_return(body)
      request
    end
    let(:response) { Rack::Response.new }
    let(:params) { {} }
    let(:body) { StringIO.new }

    context "Build Initiated" do
      before do
        allow(params).to receive(:[]).with('room').and_return('foo')
        allow(request).to receive(:body).and_return(StringIO.new(fixture('inprogress')))
      end
      it "responds when a build is initiated" do
        expect(robot).to receive(:send_message) do |target, message|
          expect(target.room).to eq('foo')
          expect(message).to include "Alejandro Torres triggered build 36"
        end
        subject.receive(request, response)
      end
    end

    context "Build Successful" do
      before do
        Lita.config.robot.locale = :en
        allow(params).to receive(:[]).with('room').and_return('foo')
        allow(request).to receive(:body).and_return(StringIO.new(fixture('successful')))
      end
      it "responds when a build is successful" do
        expect(robot).to receive(:send_message) do |target, message|
          expect(target.room).to eq('foo')
          expect(message).to include "Success"
        end
        subject.receive(request, response)
      end
    end
  end
end
