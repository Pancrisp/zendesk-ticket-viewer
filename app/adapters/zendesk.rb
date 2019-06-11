module Adapter
  class Zendesk
    class << self
      BASE_URI = 'https://sparktrail.zendesk.com/api/v2/'

      def search(endpoint, query = {})
        response, status = fetch_data(endpoint, query)
        status == 200 ? response : errors(response)
      end
      
      def errors(res)
        response = JSON.parse(res)
        error = { errors: { message: response['error'] } }
      end

      def fetch_data(endpoint, query = {})
        query_string = query.map { |k, v| "#{k}=#{v}" }.join('&')
        path = query.empty? ? endpoint : "#{endpoint}?#{query_string}"
        response = zendesk_api[path].get
        [JSON.parse(response), response.code]
      rescue RestClient::Exception => err
        err.response
      end

      def zendesk_api
        RestClient::Resource.new(
          BASE_URI,
          # uncomment these to test error handling for API authentication
          # user: 'abc',
          # password: '123',
          user: Rails.application.credentials.zendesk[:username],
          password: Rails.application.credentials.zendesk[:password],
          headers: { params: { per_page: 25 } }
        )
      end
    end
  end
end
