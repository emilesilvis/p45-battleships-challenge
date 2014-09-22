#require 'nestful'

module Api
  class Client

    def initialize(endpoint)
      @endpoint = endpoint
    end

    def register(name, email_address)
      response = call(:register, {:name => name, :email => email_address})
      parse(response.body)
    end

    def nuke(game_id, x, y)
      response = call(:nuke, {:id => game_id, :x => x, :y => y})
      parse(response.body)
    end

    private

      def call(action, data)
        response = Nestful.post("#{@endpoint}/#{action.to_s}", data, :format => :json)
        check_for_api_error!(parse(response.body))
        response
      end

      def parse(json)
        JSON.parse(json, :symbolize_names => true)
      end

      def check_for_api_error!(response)
        fail "#{response[:error]}" if response[:error]
      end

  end
end