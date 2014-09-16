require 'nestful'

module APIClient
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
      end

      def parse(json)
        JSON.parse(json, :symbolize_names => true)
      end

  end
end