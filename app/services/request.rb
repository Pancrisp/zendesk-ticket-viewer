class Request
  class << self
    BASE_URI = 'https://sparktrail.zendesk.com/api/v2/'

    def tickets
      response, status = fetch_data("tickets.json")
      status == 200 ? response : errors(response)
    end

    def ticket(id)
      response, status = fetch_data("tickets/#{id}.json")
      status == 200 ? response : errors(response)
    end

    def find_user(id)
      response, status = fetch_data("users/#{id}.json")
      status == 200 ? response : errors(response)
    end
    
    def errors(res)
      response = JSON.parse(res)
      error = { errors: { message: response['error'] } }
      response.merge(error)
    end

    def fetch_data(path)
      response = tickets_api[path].get
      [JSON.parse(response), response.code]
    rescue RestClient::Exception => err
      err.response
    end

    def tickets_api
      RestClient::Resource.new(
        BASE_URI,
        # uncomment these to test error handling for API authentication
        # :user => 'abc',
        # :password => '123',
        :user => Rails.application.credentials.zendesk[:username],
        :password => Rails.application.credentials.zendesk[:password],
        :headers => { params: { per_page: 25 } }
      )
    end
  end
end
