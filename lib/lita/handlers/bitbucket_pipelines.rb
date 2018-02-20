module Lita
  module Handlers
    class BitbucketPipelines < Handler
      http.post "/bitbucket-pipelines", :receive

      def receive(request, response)
        I18n.locale = Lita.config.robot.locale

        room = request.params['room']
        target = Source.new(room: room)
        data = parse(request.body.read)
        message = format(data)
        return if message.nil?
        robot.send_message(target, message)
      end

      private

      def parse(json)
        MultiJson.load(json, symbolize_keys: true)
      rescue MultiJson::ParseError => exception
        exception.data
        exception.cause
      end

      def format(data)
        status = data[:commit_status][:state]
        url    = data[:commit_status][:url]
        repo   = data[:commit_status][:repository][:name]
        user   = data[:commit_status][:commit][:author][:user][:display_name]
        build  = url.split('/').last

        case status
        when "INPROGRESS"
          t("initiated",
            build: build,
            user: user,
            repo: repo,
            url: url)
        when "SUCCESSFUL"
          t("successful",
            build: build,
            user: user,
            repo: repo,
            url: url)
        else
          t("error",
            build: build,
            user: user,
            repo: repo,
            url: url)
        end
      end

      Lita.register_handler(self)
    end
  end
end
